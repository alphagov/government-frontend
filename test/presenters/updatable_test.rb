require 'test_helper'

module UpdatableStubs
  def display_date(date)
    date
  end
end

module UpdatableWithUpdates
  def any_updates?
    true
  end
end

class UpdatableTest < ActiveSupport::TestCase
  def setup
    @updatable = Object.new
    @updatable.extend(Updatable)
    @updatable.extend(UpdatableStubs)
  end

  test '#history returns an empty array when there is no change history' do
    @updatable.extend(UpdatableWithUpdates)
    class << @updatable
      def content_item
        { 'details' => {} }
      end
    end

    assert_empty @updatable.history
  end

  test '#history returns updates when first_public_at does not match public_updated_at' do
    class << @updatable
      def content_item
        {
          'public_updated_at' => '2002-02-02',
          'details' => {
            'first_public_at' => '2001-01-01',
            'change_history' => [
              {
                'note' => 'note',
                'public_timestamp' => '2002-02-02'
              }
            ]
          }
        }
      end
    end

    assert @updatable.history.any?
    assert_equal @updatable.updated, '2002-02-02'
  end

  test '#history returns no updates when first_public_at matches public_updated_at' do
    class << @updatable
      def content_item
        {
          'public_updated_at' => '2002-02-02',
          'details' => {
            'first_public_at' => '2002-02-02',
            'change_history' => [
              {
                'note' => 'note',
                'public_timestamp' => '2002-02-02'
              }
            ]
          }
        }
      end
    end

    assert @updatable.history.empty?
    refute @updatable.updated
  end

  test '#history returns no updates when first_public_at is not present' do
    class << @updatable
      def content_item
        {
          'public_updated_at' => '2002-02-02',
          'details' => {
            'change_history' => [
              {
                'note' => 'note',
                'public_timestap' => '2002-02-02'
              }
            ]
          }
        }
      end
    end

    assert @updatable.history.empty?
    refute @updatable.updated
  end

  test '#history returns no updates when public_updated_at not present' do
    class << @updatable
      def content_item
        {
          'details' => {
            'first_public_at' => '2001-01-01',
            'change_history' => [
              {
                'note' => 'note',
                'public_timestamp' => '2002-02-02'
              }
            ]
          }
        }
      end
    end

    assert @updatable.history.empty?
    refute @updatable.updated
  end

  test '#history returns an array of hashes when there is change history' do
    @updatable.extend(UpdatableWithUpdates)
    class << @updatable
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
                     timestamp: '2016-02-29T09:24:10.000+00:00'
                   }
                 ]
  end

  test '#history returns a reverse chronologically sorted array of hashes when there is change history' do
    @updatable.extend(UpdatableWithUpdates)
    class << @updatable
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
