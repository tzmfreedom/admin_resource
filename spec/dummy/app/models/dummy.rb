# frozen_string_literal: true

class Dummy
  include ActiveModel::Model

  class << self
    def find
      Dummy.new
    end
  end

  def destroy
    true
  end

  def save
    true
  end


  def update
    true
  end
end