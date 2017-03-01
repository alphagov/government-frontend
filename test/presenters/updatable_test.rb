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
                'public_timestamp' => '2016-02-29T09:24:10.000+00:00',
              }
            ]
          }
        }
      end
    end

    assert_equal @updatable.history,
                 [
                   {
                     display_time: '2016-02-29T09:24:10.000+00:00',
                     note: 'notes',
                     timestamp: '2016-02-29T09:24:10.000+00:00' }
                 ]
  end

  test '#history returns a reverse chronologically sorted array of hashes when there is change history' do
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
                'note' => 'first',
                'public_timestamp' => '2001-01-01',
              },
              {
                'note' => 'third',
                'public_timestamp' => '2003-03-03',
              },
              {
                'note' => 'second',
                'public_timestamp' => '2002-02-02',
              }
            ]
          }
        }
      end
    end

    assert_equal @updatable.history.map { |i| i[:timestamp] }, ['2003-03-03', '2002-02-02', '2001-01-01']
  end
end
