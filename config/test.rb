# frozen_string_literal: true

h = {}
h[:key] = 'bar'
Rails.logger.debug h[:key]
