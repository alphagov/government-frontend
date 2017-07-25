require 'test_helper'

class WithdrawalTest < ActiveSupport::TestCase
  def setup
    @withdrawable = Object.new
    @withdrawable.extend(Withdrawable)
  end

  test 'something' do
    class << @withdrawable
      def withdrawn?
        true
      end

      def content_item
        {
          'title' => 'Proportion of residents who do any walking or cycling (at local authority level) (CW010)',
          'schema_name' => 'statistical_data_set',
          'withdrawn_notice' => {
            'explanation' => '<div class=\'govspeak\'><p>It has been superseded by <a href=\'https://www.gov.uk/government/statistics/local-area-walking-and-cycling-in-england-2014-to-2015\'>Local area walking and cycling in England: 2014 to 2015</a>.</p>\n</div>',
            'withdrawn_at' => '2016-07-12T09:47:15Z'
          }
        }
      end
    end

    assert @withdrawable.withdrawn?
    #assert_equal @withdrawable.content_item["title"], "Proportion of residents who do any walking or cycling (at local authority level) (CW010)"
    #assert_equal @withdrawable.page_title, "moo"
    #assert @withdrawable.withdrawal_notice_component.any?
    #assert_equal @withdrawable.page_title, "Proportion of residents who do any walking or cycling (at local authority level) (CW010)"
  end
end
