class MembersController < ApplicationController
  def index
    @members = Member.all
  end

  def new
    @member = Member.new
  end

  def create
    @member = Member.new(member_params)

    respond_to do |format|
      if @member.save
        # Tell the UserMailer to send a welcome Email after save
        MemberMailer.registration_confirmation(@member).deliver

        format.html { redirect_to(action: :index, notice: 'Member was successfully created.Please verify your email address.') }
        format.json { render json: @member, status: :created, location: @member }
      else
        format.html { render action: 'new' }
        format.json { render json: @member.errors, status: :unprocessable_entity }
      end
    end
  end

  def confirm_email
    @member = Member.find_by_confirm_token(params[:id])
    if @member
      @member.email_activate
      MemberMailer.welcome_email(@member).deliver
      flash[:success] = "Welcome to the Sample App! Your email has been confirmed.
      Please sign in to continue."
      redirect_to action: :index
    else
      flash[:error] = "Sorry. User does not exist"
      redirect_to action: :index
    end
  end

  def edit
    @member = Member.find(params[:id])
  end

  def update
    @member = Member.find(params[:id])
    @member.update_attributes(params[:member])
    redirect_to action: :index
  end

  def destroy
    @member = Member.find(params[:id])
    @member.destroy!
    redirect_to action: :index
  end

  def graph
    dict = {}
    edges = []
    node_data = []
    # create dict used by edge lines and write node lines
    Member.active.each_with_index do |member, i|
      switch_node_name = i
      dict[member.id] = switch_node_name
      node_data << { name: member.name }
    end

    # create edge lines
    Group.all.each do |group|
      pairwise_combos = group.members.active.pluck(:id).combination(2)
      pairwise_combos.each do |c|
        edges << [dict[c.first], dict[c.last]]
      end
    end
    @node_data_str = node_data.to_json.html_safe
    @link_data_str = edges.to_json.html_safe
  end

  private

  def member_params
    params.require(:member).permit!
  end
end
