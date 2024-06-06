# frozen_string_literal: true

# Base class for all models, providing common functionality
class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
end
