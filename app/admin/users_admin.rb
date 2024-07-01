Trestle.resource(:users) do
  menu do
    item '返回主系统', '/', icon: 'fa fa-arrow-left', priority: :first
    item "用户管理", icon: "fa fa-user"
  end

  scope :all, default: true

  search do |query|
    if query
      User.where("email like ?", "%#{query}%")
    else
      User.all
    end
  end

  # collection do
  #   User.order(created_at: :desc)
  # end

  # search do |q|
  #   q ? collection.where("email like ?", "%#{q}%") : collection
  # end

  # Customize the table columns shown on the index view.
  #
  table do
    column :id
    column :email
    column :address
    column :invitation_code
    column :role
    column :confirmed_at
    column :created_at, align: :center
    actions
  end

  # Customize the form fields shown on the new/edit views.
  #
  form do |user|
    text_field :email
    text_field :address
    text_field :invitation_code
    text_field :role
    text_field :confirmed_at
  
    row do
      col(sm: 3) { datetime_field :updated_at }
      col(sm: 3) { datetime_field :created_at }
    end
  end

  # By default, all parameters passed to the update and create actions will be
  # permitted. If you do not have full trust in your users, you should explicitly
  # define the list of permitted parameters.
  #
  # For further information, see the Rails documentation on Strong Parameters:
  #   http://guides.rubyonrails.org/action_controller_overview.html#strong-parameters
  #
  # params do |params|
  #   params.require(:user).permit(:name, ...)
  # end
end
