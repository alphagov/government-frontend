require 'test_helper'

class UpdatableTest < ActiveSupport::TestCase
  def setup
    @updatable = Object.new
    @updatable.extend(Updatable)
  end

  test '#history returns an empty array when there is no change history' do
    class << @updatable
      def any_updates?
        true
      end

      def content_item
        { 'details' => {} }
      end
    end

    assert_empty @updatable.history
  end

  test '#history returns an array of hashes when there is change history' do
    class << @updatable
      def any_updates?
        true
      end

      def display_date(date)
        date
      end

      def content_item
        {
          'details' => {
            'change_history' => [
              {
                'note' => 'notes',
                'public_timestamp' => 'timestamp',
              }
            ]
          }
        }
      end
    end

    assert_equal @updatable.history,
                 [
                   {
                     display_time: 'timestamp',
                     note: 'notes',
                     timestamp: 'timestamp' }
                 ]
  end
end
