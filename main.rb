require 'rubygems'
require 'bundler/setup'
require 'telegram/bot'
require 'yaml'

def read_token
  if File.exist?('config/config.yaml')
    config = YAML.load_file('config/config.yaml')
    config['token']
  else
    puts 'File config/config.yaml not found! Trying to read the token from BOT_TOKEN'
    ENV['BOT_TOKEN']
  end
end

def generate_results(message, phrases)
  phrases.map do |arr|
    message.query = 'pac' if message.query.empty?

    msgres = '*' + arr[1] + arr[2] + message.query + '*'

    message_content = Telegram::Bot::Types::InputTextMessageContent.new(
      message_text: msgres,
      parse_mode: 'Markdown'
    )

    Telegram::Bot::Types::InlineQueryResultArticle.new(
      id: arr[0],
      title: arr[1],
      input_message_content: message_content,
      description: arr[2] + message.query
    )
  end
end

token = read_token

raise "Can't find bot token in the config file or in BOT_TOKEN environmental variable, aborting" unless token

phrases = [
  [1,  'Diffidare',            ' da '],
  [2,  'Boicottare',           ' '],
  [3,  'Dubitare',             ' di '],
  [4,  'Sospettare',           ' di '],
  [5,  'Discostarsi',          ' da '],
  [6,  'Discriminare',         ' '],
  [7,  'Deprecare',            ' '],
  [8,  'Mettere in questione', ' '],
  [9,  'Bullizzare',           ' '],
  [10, 'Assassinare',          ' '],
  [11, 'Vomitare su',          ' '],
  [12, 'Saccheggare',          ' '],
  [13, 'Torturare',            ' '],
  [14, 'Gambizzare',           ' ']
]

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    case message
    when Telegram::Bot::Types::InlineQuery
      results = generate_results(message, phrases)

      begin
        bot.api.answer_inline_query(inline_query_id: message.id, results: results)
      rescue Telegram::Bot::Exceptions::ResponseError => e
        puts e.message
      end
    end
  end
end
