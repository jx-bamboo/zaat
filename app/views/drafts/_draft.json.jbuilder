json.extract! draft, :id, :prompt, :image, :model, :user_id, :created_at, :updated_at
json.url draft_url(draft, format: :json)
