module Gpt
  module Tiktoken
    extend self

    DEFAULT_MODEL='text-embedding-ada-002'

    def count(string, model: DEFAULT_MODEL)
      Tiktoken.get_tokens(string, model: model).length
    end

    def get_tokens(string, model: DEFAULT_MODEL, include_decoding: false)
      encoder = ::Tiktoken.encoding_for_model(model)
      tokens = encoder.encode(string)
      if include_decoding
        tokens.map do |token|
          [token, encoder.decode(token)]
        end
      else
        tokens
      end

    end
  end
end
