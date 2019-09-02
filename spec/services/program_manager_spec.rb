
module System
  #tests to simple, practically testing if ActiveRecord works.
  describe System::ProgramManagerService do
    describe "getInstallPrograms" do
      it "should return two programs" do
        expect(ProgramManagerService.instance.get_installed_programs().count).to eql(2)
      end

      it "should return \"appOne\"" do
        expect(ProgramManagerService.instance.get_installed_programs().find_index {|program|
          program.name == "appOne"
          }).not_to eql(nil)
      end

      it "should return \"appTwo\"" do
        expect(ProgramManagerService.instance.get_installed_programs().find_index {|program|
          program.name == "appTwo"
          }).not_to eql(nil)
      end
    end
  end
end
