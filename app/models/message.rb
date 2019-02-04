class Message < ApplicationRecord
  belongs_to :autor

  after_create_commit { MessageBroadcastJob.perform_later self }

end
