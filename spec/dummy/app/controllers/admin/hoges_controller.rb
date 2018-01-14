module Admin
  class HogesController < ApplicationController
    include ::AdminResource
    actions :index, :show

    index_params :name, :in, :bl
    show_params :name, :in, :bl
    search_params :name, :in, :bl
    permitted_params :name, :in, :bl
  end
end
