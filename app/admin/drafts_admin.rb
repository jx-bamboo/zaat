Trestle.resource(:drafts) do
  menu do
    item "文件管理", icon: "fa fa-file"
  end

  # Customize the table columns shown on the index view.
  #
  table do
    column :id
    column :txhash
    column :model_file_count
    column :status
    column :user
    
    column :created_at, align: :center
    actions
  end

  # Customize the form fields shown on the new/edit views.
  #
  form do |draft|
    tab :content do
      text_field :id
      text_field :txhash
      text_field :user, value: draft.user.email
      # file_field :model_file, multiple: true
      
      row do
        col { datetime_field :updated_at }
        col { datetime_field :created_at }
      end
  
      row do
        col { radio_button :status, "pending" }
        col { radio_button :status, "creating" }
        col { radio_button :status, "completed" }
      end
      
    end

    tab :model_file do
      draft.model_file.each do |file|
        col {file.filename}
      end
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
  #   params.require(:draft).permit(:name, ...)
  # end
end
