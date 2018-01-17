module Admin
  class HogesController < ApplicationController
    include ::AdminResource
    actions :index, :show, :edit, :new, :update, :create, :destroy

    index_params :name, :in, :bl, :created_at
    show_params :name, :in, :bl, :created_at
    search_params :name, :in, :bl, :created_at
    permitted_params :name, :in, :bl
  end
end
