
module Api::System
  describe Api::System::ProgramManagerService do
    describe "getInstallPrograms" do
      it "should return two programs" do
        expect(ProgramManagerService.instance.getInstallPrograms().count).to eql(2)
      end

      it "should return \"appOne\"" do
        expect(ProgramManagerService.instance.getInstallPrograms().find_index {|program|
          program.name == "appOne"
          }).not_to eql(nil)
      end

      it "should return \"appTwo\"" do
        expect(ProgramManagerService.instance.getInstallPrograms().find_index {|program|
          program.name == "appTwo"
          }).not_to eql(nil)
      end
    end
  end
end
