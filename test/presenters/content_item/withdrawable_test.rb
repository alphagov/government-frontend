require 'test_helper'

class ContentItemWithdrawableTest < ActiveSupport::TestCase
  def setup
    @withdrawable = Object.new
    @withdrawable.extend(ContentItem::Withdrawable)
    I18n.locale = :cy
  end

  def teardown
    I18n.locale = I18n.default_locale
  end

  test 'content item is withdrawn' do
    class << @withdrawable
      def content_item
        {
          'withdrawn_notice' => {
            'withdrawn_at' => '2016-07-12T09:47:15Z'
          }
        }
      end
    end

    assert @withdrawable.withdrawn?
  end

  test 'page title has withdrawn appended if content withdrawn' do
    class << @withdrawable
      def title
        content_item["title"]
      end

      def content_item
        {
          'title' => 'Proportion of residents who do any walking or cycling (at local authority level) (CW010)',
          'withdrawn_notice' => {
            'withdrawn_at' => '2016-07-12T09:47:15Z'
          }
        }
      end
    end

    assert_equal @withdrawable.page_title, "[Withdrawn] Proportion of residents who do any walking or cycling (at local authority level) (CW010)"
  end

  test 'notice title and description are generated correctly' do
    class << @withdrawable
      def schema_name
        'news_article'
      end

      def display_date(date)
        date
      end

      def content_item
        {
          'title' => 'Proportion of residents who do any walking or cycling (at local authority level) (CW010)',
          'withdrawn_notice' => {
            'explanation' => '<div class=\'govspeak\'><p>It has been superseded by <a href=\'https://www.gov.uk/government/statistics/local-area-walking-and-cycling-in-england-2014-to-2015\'>Local area walking and cycling in England: 2014 to 2015</a>.</p>\n</div>',
            'withdrawn_at' => '2016-07-12T09:47:15Z'
          }
        }
      end
    end

    assert_equal @withdrawable.withdrawal_notice_component[:title], "This news article was withdrawn on <time datetime=\"2016-07-12T09:47:15Z\">12 July 2016</time>"
    assert_equal @withdrawable.withdrawal_notice_component[:description_govspeak], "<div class='govspeak'><p>It has been superseded by <a href='https://www.gov.uk/government/statistics/local-area-walking-and-cycling-in-england-2014-to-2015'>Local area walking and cycling in England: 2014 to 2015</a>.</p>\\n</div>"
  end

  test 'notice title presents only in English, even if locale is set to another language' do
  # This is to prevent the withdrawal notices on translated editions
  # displaying a combination of languages in their titles.
    class << @withdrawable
      def schema_name
        'publication'
      end

      def content_item
        {
          'title' => 'Proportion of residents who do any walking or cycling (at local authority level) (CW010)',
          'withdrawn_notice' => {
            'explanation' => '<div class=\'govspeak\'><p>It has been superseded by <a href=\'https://www.gov.uk/government/statistics/local-area-walking-and-cycling-in-england-2014-to-2015\'>Local area walking and cycling in England: 2014 to 2015</a>.</p>\n</div>',
            'withdrawn_at' => '2016-07-12T09:47:15Z'
          },
          'locale': 'cy'
        }
      end
    end

    assert_equal @withdrawable.withdrawal_notice_component[:title], "This publication was withdrawn on <time datetime=\"2016-07-12T09:47:15Z\">12 July 2016</time>"
  end
end
