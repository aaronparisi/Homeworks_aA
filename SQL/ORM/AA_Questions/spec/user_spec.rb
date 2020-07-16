require 'user'
require 'byebug'
require 'rspec'

describe User do
    after(:each) do
        system("cat ~/Desktop/CS/AppAcademy2020/Homeworks_aA/SQL/ORM/AA_Questions/import_db.sql | sqlite3 questions.db")
    end
    describe '::all' do
        it "calls ModelBase::all" do
            expect(ModelBase).to receive(:all).with('users', User)
            User.all
        end
    end

    describe '::find_by_id' do
        it "calls ModelBase::find_by_matchers" do
            expect(ModelBase).to receive(:find_by_id).with('users', ['id'], [1], User)
            User.find_by_id(1)
        end
    end

    describe '::find_by_fname' do
        it "calls ModelBase::find_by_matchers"
    end

    describe '::find_by_lname' do
        it "calls ModelBase::find_by_matchers"
    end

    describe '::find_by_full_name' do
        it "calls ModelBase::find_by_matchers"
    end

    describe '::has_user_with_id?' do
        let (:truthy) {User.has_user_with_id?(3)}
        let (:falsey) {User.has_user_with_id?(3000)}

        context "when user with id exists in database" do
            it "returns true" do
                expect(truthy).to be true
            end
        end

        context "else" do
            it "returns false" do
                expect(falsey).to be false
            end
        end
    end

    describe '#save' do

        it "calls ModelBase#save with self" do
            user = User.new('fname' => 'John', 'lname' => 'Doe')
            expect(ModelBase).to receive(:save).with(user)
            user.save
        end

        context "when the user does not have an id" do
            it "sets the id" do
                user = User.new('fname' => 'John', 'lname' => 'Doe')
                user.save
                expect(user.id).to_not be nil
            end
        end
    end

    describe '#authored_questions' do
        subject (:christineparisi) {User.find_by_id(1)}
        it "calls Question::find_by_author_id" do
            expect(Question).to receive(:find_by_author_id).with(1)
            christineparisi.authored_questions
        end
    end

    describe '#liked_questions' do
        subject (:christineparisi) {User.find_by_id(1)}
        it "calls QuestionLike::likers_questions_full" do
            expect(QuestionLike).to receive(:likers_questions_full).with(1)
            christineparisi.liked_questions
        end
    end

    describe '#followed_questions' do
        subject (:christineparisi) {User.find_by_id(1)}
        it "calls QuestionFollow::followers_questions_full" do
            expect(QuestionFollow).to receive(:followers_questions_full).with(1)
            christineparisi.followed_questions
        end
    end

    describe '#authored_replies' do
        subject (:christineparisi) {User.find_by_id(1)}
        it "calls Reply::find_by_author_id" do
            expect(Reply).to receive(:find_by_author_id).with(1)
            christineparisi.authored_replies
        end
    end

    describe '#liked_replies' do
        subject (:christineparisi) {User.find_by_id(1)}
        it "calls ReplyLike::find_by_liker_id" do
            expect(ReplyLike).to receive(:find_by_liker_id).with(1)
            christineparisi.liked_replies
        end
    end

    describe '#average_karma' do
        subject (:christineparisi) {User.find_by_id(1)}
        subject (:andrewparisi) {User.find_by_id(7)}
        subject (:sarahparisi) {User.find_by_id(10)}
        it "returns the average number of likes to a user's questions" do
            expect(christineparisi.average_karma).to eq(0.0)
            expect(andrewparisi.average_karma).to eq(3.0)
        end

        context 'when the user has not authored any questions' do
            it 'returns nil' do
                expect(sarahparisi.average_karma).to be_nil
            end
        end
    end

    describe '#remove' do
        # it "removes the user from the database"
        # it "removes all the user's authored questions"
        # it "removes all the user's likes"
        # it "removes all the user's follows"
        # it "removes all likes of the user's questions"
        # it "removes all follows of the user's questions"
        # it "removes all the user's replies"
        # it "removes all the user's replies' children"
        # it "removes all likes to these replies"
        # it "does not remove other users from the database"
        # it "does not remove parent replies"
        # it "does not remove other users' questions"
    end
end

# puts "initial user count: #{User.all.count}" # 10

# user3 = User.find_by_id(3)
# puts "user3: name = '#{user3.fname} #{user3.lname}', class: #{user3.class}"
# # "Vinny Ruzzo"
