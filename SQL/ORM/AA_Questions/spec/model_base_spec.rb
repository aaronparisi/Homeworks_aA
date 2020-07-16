require 'model_base'
require 'byebug'
require 'rspec'

describe User do
    after(:each) do
        system("cat ~/Desktop/CS/AppAcademy2020/Homeworks_aA/SQL/ORM/AA_Questions/import_db.sql | sqlite3 questions.db")
    end

    describe '::find_by_matchers' do
    end

    describe '::save' do
        it "creates a new ModelBase using the passed object" do
            expect(ModelBase).to receive(:new).and_call_original
            ModelBase.save(User.find_by_id(1))
        end

        context "when the object has been added already" do
            it "calls update" do
                expect(ModelBase).to receive(:update)
                ModelBase.save(User.find_by_id(1))
            end
        end

        context "when the user has not been added already" do
            it "calls create" do
                expect(ModelBase).to receive(:create)
                ModelBase.save(User.new('fname' => 'John', 'lname' => 'Doe'))
            end
        end
    end

    describe '::create' do
        let (:new_user) {User.new('fname' => 'Sally', 'lname' => 'Mae')}
        let (:mb_new) {ModelBase.new(new_user)}

        context "when object is already in db" do
            it "raises an error" do
                christineparisi = User.find_by_id(1)
                mb_christine = ModelBase.new(christineparisi)
                expect{ModelBase.create(mb_christine)}.to raise_error("already in db")
            end
        end

        it "adds the object to the database" do
            all_before = User.all
            expect{ModelBase.create(mb_new)}.to change {User.all.length}.from(11).to(12)
        end

        it "returns the newly assigned id" do
            expect(ModelBase.create(mb_new)).to be_an(Integer)
        end
    end

    describe '::update' do
        let (:christineparisi) {User.find_by_id(1)}
        let (:mb_christine) {ModelBase.new(christineparisi)}

        context "when the object is not in the db" do
            it "raises an error" do
                sallymae = User.new('fname' => "Sally", 'lname' => "Mae")
                mb_sally = ModelBase.new(sallymae)
                expect{ModelBase.update(mb_sally)}.to raise_error("not in db")
            end
        end

        context "when the users info has changed" do
            it "updates the users info" do
                christineparisi.lname = "Ruzzo"
                mb_christine = ModelBase.new(christineparisi)
                ModelBase.update(mb_christine)
                expect(User.find_by_id(1).lname).to eq("Ruzzo")
            end
        end

        context "when the users info has not changed" do
            it "does not change anything in the db" do
                ModelBase.update(mb_christine)
                expect(User.find_by_id(1).lname).to eq("Parisi")
            end
        end

        it "does not add or subtract users from the db" do
            christineparisi.lname = "Ruzzo"
            mb_christine = ModelBase.new(christineparisi)
            expect{ModelBase.update(mb_christine)}.to_not change{User.all.length}
        end

        it "returns true upon success" do
            expect(ModelBase.update(mb_christine)).to be true
        end
    end
end