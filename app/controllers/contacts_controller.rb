class ContactsController < Spree::StoreController
  before_action :set_contact, only: [:show, :edit, :update, :destroy]
  layout 'spree/layouts/spree_application'

  MASTER_LIST_ID='3'

  # GET /contacts
  # GET /contacts.json
  def index
    # @contacts = Contact.all
  end

  # GET /contacts/1
  # GET /contacts/1.json
  def show
  end

  # GET /contacts/new
  def new
    if spree_current_user
      email = spree_current_user.email
      @allow_change_to_email = spree_current_user.has_spree_role?('admin')
      @contact = Contact.find_by_email(email)
    else
      email = ''
      @allow_change_to_email = false
    end
    @contact = Contact.new(email_address: email, lists: MASTER_LIST_ID) unless @contact
    respond_to do |format|
      if @contact.cc && @contact.in_list?(MASTER_LIST_ID)  # email address found at Constant Contact
        redirect_to edit_contact_path(@contact.id) and return
      else
        format.html { render :new }
      end
    end


    # See if user already on mailing list.  If so, edit
  end

  # GET /contacts/1/edit
  def edit
    @allow_change_to_email = false
  end

  def subscribe

  end
  # Passed params[:list_id] to unsubscribe from
  def unsubscribe

  end

  # POST /contacts
  # POST /contacts.json
  def create
    @contact = Contact.new(contact_params)

    respond_to do |format|
      if @contact.save
        # format.html { redirect_to @contact, notice: 'Contact was successfully created.' }
        flash.now[:notice] = 'Thank You for Signing Up.'
        format.html { render :show }
        format.json { render :show, status: :created, location: @contact }
      else
        @allow_change_to_email = true
        format.html { render :new }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /contacts/1
  # PATCH/PUT /contacts/1.json
  def update
    respond_to do |format|
      if @contact.update(contact_params)
        format.html { redirect_to @contact, notice: 'Contact was successfully updated.' }
        format.json { render :show, status: :ok, location: @contact }
      else
        format.html { render :edit }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.json
  def destroy
    @contact.destroy
    respond_to do |format|
      format.html { redirect_to contacts_url, notice: 'Contact was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_contact
      @contact = Contact.find(params[:id]) unless params[:id].to_s.empty?
      @contact ||= Contact.find_by_email(params[:email_address]) unless params[:email_address].to_s.empty?
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def contact_params
      params.require(:contact).permit(:id, :status, :first_name, :middle_name, :last_name, :confirmed, :email_address, :prefix_name, :job_title, :addresses, :company_name, :home_phone, :work_phone, :cell_phone, :fax, :custom_fields, :lists, :source_details, :notes, :source)
    end
end
