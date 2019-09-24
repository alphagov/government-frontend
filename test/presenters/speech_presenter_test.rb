require "presenter_test_helper"

class SpeechPresenterTest
  class SpeechTestCase < PresenterTestCase
    def schema_name
      "speech"
    end
  end

  class PresentedSpeech < SpeechTestCase
    test "presents the schema name" do
      assert_equal schema_item["schema_name"], presented_item.schema_name
    end

    test "#published returns a formatted date of the day the content item became public" do
      assert_equal "8 March 2016", presented_item.published
    end

    test "presents a description" do
      assert_equal schema_item["description"], presented_item.description
    end

    test "presents a speech location" do
      assert_equal schema_item["details"]["location"], presented_item.important_metadata["Location"]
    end

    test "presents how speech was delivered" do
      assert_equal "Delivered on", presented_item.delivery_type
    end

    test "presents a delivered on date with speech type explanation for the metadata component" do
      assert_equal '<time datetime="2016-02-02T00:00:00+00:00">2 February 2016</time> (Original script, may differ from delivered version)', presented_item.delivered_on_metadata
    end

    test "presents the body" do
      expected_body = schema_item["details"]["body"]

      assert_equal expected_body, presented_item.body
    end

    test "from includes speaker" do
      assert presented_item.from.include?("<a class=\"govuk-link\" href=\"/government/people/andrea-leadsom\">The Rt Hon Andrea Leadsom MP</a>")
    end
  end

  class TranscriptPresentedSpeech < SpeechTestCase
    def example_schema_name
      "speech-transcript"
    end

    test "presents a delivered on date with speech type explanation for the metadata component" do
      assert_equal '<time datetime="2016-02-02T00:00:00+00:00">2 February 2016</time> (Original script, may differ from delivered version)', presented_item.delivered_on_metadata
    end
  end

  class WrittenStatementParliamentPresentedSpeech < SpeechTestCase
    def example_schema_name
      "speech-written-statement-parliament"
    end

    test "presents the speech as being delivered" do
      assert_equal "Delivered on", presented_item(example_schema_name).delivery_type
    end

    test "presents a delivered on date without an explanation" do
      assert_equal '<time datetime="2016-12-20T15:00:00+00:00">20 December 2016</time>', presented_item(example_schema_name).delivered_on_metadata
    end
  end

  class AuthoredArticlePresentedSpeech < SpeechTestCase
    def example_schema_name
      "speech-authored-article"
    end

    test "presents the speech as being written" do
      assert_equal "Written on", presented_item(example_schema_name).delivery_type
    end

    test "presents a delivered on date without an explanation" do
      assert_equal '<time datetime="2016-04-05T00:00:00+01:00">5 April 2016</time>', presented_item(example_schema_name).delivered_on_metadata
    end
  end

  class SpeakerWithoutProfilePresentedSpeech < SpeechTestCase
    def example_schema_name
      "speech-speaker-without-profile"
    end

    test "includes speaker without profile in from_with_speaker" do
      assert_equal [
        "<a class=\"govuk-link\" href=\"/government/organisations/prime-ministers-office-10-downing-street\">Prime Minister&#39;s Office, 10 Downing Street</a>",
        "<a class=\"govuk-link\" href=\"/government/organisations/cabinet-office\">Cabinet Office</a>",
        "Her Majesty the Queen"
        ], presented_item(example_schema_name).from
    end
  end
end
