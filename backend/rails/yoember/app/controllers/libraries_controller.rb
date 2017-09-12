class LibrariesController < ApplicationController
  before_action :set_library, only: [:show, :update, :destroy]

  # GET /libraries
  def index
    @libraries = Library.order(name: :asc)
    json_response(Oj.dump(json_for(@libraries, meta: meta), mode: :compat))
  end

  # GET /libraries/:id
  def show
    if @library
      json_response(Oj.dump(json_for(@library, meta: meta), mode: :compat))
    else
      json_response(Oj.dump(json_for(@library.errors, meta: default_meta), status: :unprocessable_entity, mode: :compat))
    end
  end

  # POST /libraries
  def create
    @library = Library.new(library_params)

    if @library.save
      json_response(Oj.dump(json_for(@library, meta: meta), mode: :compat))
    else
      json_response(Oj.dump(json_for(@library.errors, meta: default_meta), status: :unprocessable_entity, mode: :compat))
    end
  end

  # PUT /libraries/:id
  def update
    if @library.update(library_params)
      #head :no_content
      json_response(Oj.dump(json_for(@library, meta: meta), mode: :compat))
    else
      json_response(Oj.dump(json_for(@library.errors, meta: default_meta), status: :unprocessable_entity, mode: :compat))
    end
  end

  # DELETE /libraries/:id
  def destroy
    if @library.destroy
      # head :no_content
      json_response(Oj.dump({message: "The library has been deleted", meta: meta}, mode: :compat))
    else
      json_response(Oj.dump(json_for(@library.errors, meta: default_meta), status: :unprocessable_entity, mode: :compat))
    end
  end

  private

  def set_library
    @library = Library.find(params[:id])
  end

  def library_params
    ActiveModelSerializers::Deserialization.jsonapi_parse(params)
  end
end
