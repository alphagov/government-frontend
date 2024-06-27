RSpec.describe("AllComponents", type: :view) do
  Dir.glob("app/views/components/*.erb").each do |filename|
    template = filename.split("/").last
    component_name = template.sub("_", "").sub(".html", "").sub(".erb", "").gsub("-", "_")

    describe(component_name) do
      yaml_file = "#{__dir__}/../../app/views/components/docs/#{component_name}.yml"

      it "is documented" do
        expect(File).to exist(yaml_file)
      end

      it "has the correct documentation" do
        yaml = YAML.unsafe_load_file(yaml_file)

        expect(yaml["name"]).to be_truthy
        expect(yaml["description"]).to be_truthy
        expect(yaml["examples"]).to be_truthy
        expect((yaml["accessibility_criteria"] or yaml["shared_accessibility_criteria"])).to be_truthy
      end

      it "has the correct class in the ERB template" do
        erb = File.read(filename)
        class_name = "app-c-#{component_name.dasherize}"

        expect(erb).to include(class_name)
      end

      it "has a correctly named template file" do
        template_file = "#{__dir__}/../../app/views/components/_#{component_name}.html.erb"

        expect(File).to exist(template_file)
      end

      it "has a correctly named spec file" do
        rspec_file = "#{__dir__}/../../spec/components/#{component_name.tr('-', '_')}_spec.rb"

        expect(File).to exist(rspec_file)
      end

      it "has a correctly named SCSS file" do
        css_file = "#{__dir__}/../../app/assets/stylesheets/components/_#{component_name.tr('_', '-')}.scss"

        expect(File).to exist(css_file)
      end

      it "does not use `html_safe`" do
        file = File.read(filename)

        expect(file).not_to include("html_safe")
      end
    end
  end
end
