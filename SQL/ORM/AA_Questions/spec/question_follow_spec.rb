require 'question_follow'
require 'byebug'
require 'rspec'

describe QuestionFollow do
    after(:each) do
        system("cat ~/Desktop/CS/AppAcademy2020/Homeworks_aA/SQL/ORM/AA_Questions/import_db.sql | sqlite3 questions.db")
    end

    describe '::all' do
        it "returns an array of QuestionFollows" do
            all = QuestionFollow.all
            expect(all).to be_an(Array)
            expect(all).to all(be_a(QuestionFollow))
        end
    end

    describe '::find_by_question_id' do
        subject (:has_follows) {Question.find_by_id(1)}
        subject (:no_follows) {Question.find_by_id(3)}

        context "when the question_id is not in the db" do
            it "raises an error" do
                expect { QuestionFollow.find_by_question_id(3000) }.to raise_error("question not in db")
            end
        end

        it "returns an array of all follows of the given question" do
            has_found = QuestionFollow.find_by_question_id(has_follows.id)
            no_found = QuestionFollow.find_by_question_id(no_follows.id)

            expect(has_found).to be_an(Array)
            expect(has_found).to all(be_a(QuestionFollow))
            expect(has_found.length).to eq(2)
            expect(no_found.length).to eq(0)
        end
    end

    describe '::find_by_follower_id' do
        context "when the user id is not found in the db" do
            it "raises an error" do
                expect { QuestionFollow.find_by_follower_id(3000) }.to raise_error("user not in db")
            end
        end

        it "returns an array of all QuestionFollows by the given user" do
            christine_follows = QuestionFollow.find_by_follower_id(1)
            larry_follows = QuestionFollow.find_by_follower_id(2)

            expect(christine_follows).to be_empty

            expect(larry_follows).to be_an(Array)
            expect(larry_follows).to all(be_a(QuestionFollow))
            expect(larry_follows.length).to eq(1)
        end
    end

    describe '::question_follows_ids' do
        context "when the question_id is not in the db" do
            it "raises an error" do
                expect { QuestionFollow.question_follows_ids(3000) }.to raise_error("question not in db")
            end
        end

        it "returns an array of user id's who have followed the question" do
            q1_follows = QuestionFollow.question_follows_ids(1)
            q3_follows = QuestionFollow.question_follows_ids(3)
            
            expect(q3_follows).to be_empty
            expect(q1_follows).to be_an(Array)
            expect(q1_follows).to all(be_an(Integer))

            checker = q1_follows.map {|id| User.find_by_id(id)}
            checker.map! {|usr| usr.followed_questions}
            checker.map! do |q_arr|
                q_arr.map! {|q| q.id}
            end

            checker.each do |users_fol_q_ids|
                expect(users_fol_q_ids).to include(1)
            end
            # i.e. do all those users actually follow that question?
        end    
    end

    describe '::question_follows_full' do
        context "when the question_id is not in the db" do
            it "raises an error" do
                expect { QuestionFollow.question_follows_ids(3000) }.to raise_error("question not in db")
            end
        end

        it "returns an array of Users who have followed the question" do
            q1_follows = QuestionFollow.question_follows_full(1)
            q3_follows = QuestionFollow.question_follows_full(3)

            expect(q3_follows).to be_empty
            expect(q1_follows).to be_an(Array)
            expect(q1_follows).to all(be_a(User))

            q1_follows.each do |user|
                followed_ids = user.followed_questions.map {|q| q.id}
                expect(followed_ids).to include(1)
            end
        end
    end

    describe '::followers_question_ids' do
        subject (:ids) {QuestionFollow.followers_question_ids(2)}

        context "when the given user is not in the db" do
            it "raises an error" do
                expect { QuestionFollow.followers_question_ids(3000)}.to raise_error("user not in db")
            end
        end

        it "returns an array of ints" do
            expect(ids).to be_an(Array)
            expect(ids).to all(be_an(Integer))
        end

        it "returns all ids of questions the given user followed" do
            expect(ids.length).to eq(1)
            expect(ids.first).to eq(1)
        end
    end

    describe '::followers_questions_full' do
        subject (:qs) {QuestionFollow.followers_questions_full(2)}

        context "when the given user is not in the db" do
            it "raises an error" do
                expect {QuestionFollow.followers_questions_full(3000)}.to raise_error("user not in db")
            end
        end

        it "returns an array of Questions" do
            expect(qs).to be_an(Array)
            expect(qs).to all(be_a(Question))
        end

        it "returns all questions a user has followed" do
            expect(qs.length).to eq(1)
            expect(qs.first.title).to eq("What's the difference between HTML and CSS?")
        end
    end

    describe '::num_follows_for_question_id' do
        context "when the given question id does not match a question" do
            it "raises an error" do
                expect {QuestionFollow.num_follows_for_question_id(3000)}.to raise_error("question not in db")
            end
        end

        it "returns the number of followers a question has" do
            expect(QuestionFollow.num_follows_for_question_id(1)).to eq(2)
            expect(QuestionFollow.num_follows_for_question_id(2)).to eq(2)
            expect(QuestionFollow.num_follows_for_question_id(3)).to eq(0)
        end
    end

    describe '::num_follows_for_user_id' do
        context "when the given user id does not match a user" do
            it "raises an error" do
                expect {QuestionFollow.num_follows_for_user_id(3000)}.to raise_error("user not in db")
            end
        end

        it "returns the number of questions a user has followed" do
            expect(QuestionFollow.num_follows_for_user_id(1)).to eq(0)
            expect(QuestionFollow.num_follows_for_user_id(2)).to eq(1)
        end
    end

    describe '::most_followed_questions' do
        context "when there are no questions in the db" do
            it "returns nil" do
                ###########################
            end
        end

        it "returns an array of arrays: [Question, follow_count]" do
            most = QuestionFollow.most_followed_questions
            expect(most).to be_an(Array)
            expect(most).to all(be_an(Array))
            expect(most.first.first).to be_a(Question)
            expect(most.first.last).to be_an(Integer)
        end

        context "when there are no follows to any questions" do
            it "returns all questions with a follow count of 0" do
                #####################
            end
        end
    end

    describe '::create' do
        context "when the user has already followed the question" do
            it "raises an error" do
                qf = QuestionFollow.new('question_id' => 1, 'follower_id' => 2)
                expect { qf.create }.to raise_error("already followed")
            end
        end

        context "when the follower_id doesn't exist" do
        end

        context "when the question_id doesn't exist in the db" do
        end

        it "adds a new row to question_follows" do
            qf = QuestionFollow.new('question_id' => 1, 'follower_id' => 5)
            expect {qf.create}.to change {QuestionFollow.find_by_question_id(1).length}.from(2).to(3)
        end
    end

    describe '::remove' do
        it "removes the questionfollow from the db" do
            qf = QuestionFollow.find_by_question_id(1).first
            expect {qf.remove}.to change {QuestionFollow.find_by_question_id(1).length}.from(2).to(1)
        end
    end
end