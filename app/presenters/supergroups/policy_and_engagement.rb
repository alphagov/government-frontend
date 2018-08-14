module Supergroups
  class PolicyAndEngagement < Supergroup
    def initialize(current_path, taxon_ids, filters)
      super(current_path, taxon_ids, filters, MostRecentContent)
    end
  end
end
