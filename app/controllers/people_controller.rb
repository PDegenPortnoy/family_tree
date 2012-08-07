class PeopleController < ApplicationController
  # GET /people
  # GET /people.json
  def index
    @people = Person.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @people }
    end
  end

  # GET /people/1
  # GET /people/1.json
  def show
    @person = Person.find(params[:id])
    @spouse = @person.spouse
    @parents = @person.parents
    @siblings = @person.siblings
    @children = @person.children

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @person }
    end
  end

  # GET /people/new
  # GET /people/new.json
  def new
    logger.debug "params: #{params.inspect}"
    @person = Person.new
    @relationship = params[:relationship] #this will have parent, or child
    @origin = params[:origin] # this will have the ID of the original person if relationship is not nil

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @person }
    end
  end

  # GET /people/1/edit
  def edit
    @person = Person.find(params[:id])
  end

  # POST /people
  # POST /people.json
  def create
    relationship = params.delete('relationship')
    origin = params.delete('origin')
    unless relationship.empty?
      @person = Person.find(origin)
      @person.create_relationship(relationship, params)
    else
      @person = Person.new(params[:person])
    end

    respond_to do |format|
      if @person.save
        format.html { redirect_to @person, notice: 'Person was successfully created.' }
        format.json { render json: @person, status: :created, location: @person }
        format.js
      else
        format.html { render action: "new" }
        format.json { render json: @person.errors, status: :unprocessable_entity }
        format.js
      end
    end
  end

  # PUT /people/1
  # PUT /people/1.json
  def update
    @person = Person.find(params[:id])

    respond_to do |format|
      if @person.update_attributes(params[:person])
        format.html { redirect_to @person, notice: 'Person was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @person.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /people/1
  # DELETE /people/1.json
  def destroy
    @person = Person.find(params[:id])
    @person.destroy

    respond_to do |format|
      format.html { redirect_to people_url }
      format.json { head :no_content }
    end
  end
  
  # GET /people/1/select_spouse
  def select_spouse
    @person = Person.find(params[:id])
    @available = Person.unmarried
  end
  
  # POST /people/1/marry
  def marry
    person = Person.find(params[:id])
    spouse = Person.find(params[:spouse])
    person.marry(spouse)
    redirect_to person_path(person) and return
  end
end
