require 'rubygems'
require 'bundler/setup'
require 'telegram/bot'
require 'yaml'

config = YAML.load_file('config/config.yaml')

raise "Can't find config/config.yaml, aborting" unless config

token = config["token"]

raise "Can't find bot token in the config file, aborting" unless token

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|

    case message
    when Telegram::Bot::Types::InlineQuery
      results = [
        [1, 'Diffidare',            ' da '],
        [2, 'Boicottare',           ' '],
        [3, 'Dubitare',             ' di '],
        [4, 'Sospettare',           ' di '],
        [5, 'Discostarsi',          ' da '],
        [6, 'Discriminare',         ' '],
        [7, 'Deprecare',            ' '],
        [8, 'Mettere in questione', ' '],
        [9, 'Bullizzare',           ' ']
      ].map do |arr|

        msgres = arr[1] + arr[2] + message.query

        Telegram::Bot::Types::InlineQueryResultArticle.new(
          id: arr[0],
          title: arr[1],
          input_message_content: Telegram::Bot::Types::InputTextMessageContent.new(message_text: msgres),
          description: arr[2] + message.query
        )

      end

      bot.api.answer_inline_query(inline_query_id: message.id, results: results)
    end

  end
end
