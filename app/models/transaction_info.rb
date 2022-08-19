class TransactionInfo < ApplicationRecord
  self.primary_key = :id

  include TransactionInfos::Geometry
end
