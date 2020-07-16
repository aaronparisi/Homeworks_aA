require 'question'
require 'byebug'
require 'rspec'

describe User do
    after(:each) do
        system("cat ~/Desktop/CS/AppAcademy2020/Homeworks_aA/SQL/ORM/AA_Questions/import_db.sql | sqlite3 questions.db")
    end

    describe '::all' do
        it "returns an array of all questions as objects" do
            qs = Question.all
            expect(qs).to be_an(Array)
            expect(qs).to all(be_a(Question))
            expect(qs.length).to be(3)
        end
    end

    describe '::find_by_id' do
        context "when the given id matches a question" do
            it "returns the question" do
                q = Question.find_by_id(1)
                expect(q).to be_a(Question)
                expect(q.title).to eq("What's the difference between HTML and CSS?")
            end
        end

        context "when no matching question exists" do
            it "returns nil" do
                expect(Question.find_by_id(3000)).to be_nil
            end
        end
    end

    describe '::find_by_title' do
        context "when the given string matches a question's title" do
            matches = Question.find_by_title("What")
            it "returns an array of matching Questions" do
                expect(matches).to be_an(Array)
                expect(matches).to all(be_a(Question))
                # "expect every element in matches to have a
                # .title attribute whose value contains the search str"

            end

            it "includes partial matches" do
                expect(matches.length).to eq(3)
            end
        end

        context "when no match is found" do
            it "returns an empty array" do
                expect(Question.find_by_title("feces")).to be_empty
            end
        end
    end

    describe '::find_by_body' do
        context "when the given string matches question(s) body" do
            matches = Question.find_by_body("programming")
            it "returns an array of matching Questions" do
                expect(matches).to be_an(Array)
                expect(matches).to all(be_a(Question))
                # all matches have 'programming' in their bodies??
            end

            it "includes partial matches" do
                expect(matches.length).to eq(2)
            end
        end

        context "when the given string does not match any questions" do
            it "returns an empty array" do
                expect(Question.find_by_body("feces")).to be_empty
            end
        end
    end

    describe '::find_by_author_id' do
        context "when the given integer matches" do
            matches = Question.find_by_author_id(1)
            it "returns an array of questions authored by the given user" do
                expect(matches).to be_an(Array)
                expect(matches).to all(be_a(Question))
                expect(matches.first.id).to eq(1)
            end
        end

        context "when no matches are found" do
            it "returns an empty array" do
                expect(Question.find_by_author_id(3000)).to be_empty
            end
        end
    end

    describe '::most_followed' do
        context "when there are no questions in the db" do
            it "returns nil" do
                # how to test this??
            end
        end

        context "when there are no follows in the db" do
            it "returns nil" do
                # how to test this??
            end
        end

        context "when there are followed questions in the db" do
            tops = Question.most_followed
            it "returns an array of questions and follow counts" do
                expect(tops).to be_an(Array)
                expect(tops).to all(be_an(Array))
            end

            it "returns all questions with the top number of followers" do
                # expect all elements to have the same num followers
                # how do I test that it's actually returning the tops??
            end
        end
    end

    describe '::most_liked' do
    end

    describe '::has_question_with_id?' do
        context "when question matches given id" do
            it "returns true" do
                expect(Question.has_question_with_id?(2)).to be true
            end
        end

        context "else" do
            it "returns false" do
                expect(Question.has_question_with_id?(3000)).to be false
            end
        end
    end

describe '#create' do
        subject (:new_question) {
            Question.new('title' => 'Waddup tho', 
            'body' => 'witcho stank ass',
            'author_id' => 8)
        }

        context "when question is already in db" do
            it "raises an error" do
                first_question = Question.find_by_id(1)
                expect{first_question.create}.to raise_error("already asked")
            end
        end

        context "when question title already exists" do
            it "raises an error" do
                rep_question = Question.new('title' => 'What is SQL?',
                                            'body' => 'fake',
                                            'author_id' => 3)
                expect{rep_question.create}.to raise_error("title already exists")
            end
        end

        it "adds the question to the database" do
            expect{new_question.create}.to change {Question.all.length}.from(3).to(4)
        end

        it "assigns an id to the given user" do
            new_question.create
            expect(new_question.id).to_not be(nil)
        end

        it "returns the newly assigned id" do
            expect(new_question.create).to be_an(Integer)
        end
    end

    describe '#update' do
        subject (:first_question) {Question.find_by_id(1)}

        context "when the question is not in the db" do
            it "raises an error" do
                fake = Question.new('title' => 'Do I even care about the answer?',
                                    'body' => 'fake',
                                    'author_id' => 2)
                expect{fake.update}.to raise_error("question not in db")
            end
        end

        context "when the question's info has changed" do
            it "updates the questions info" do
                first_question.body = "repl"
                first_question.update
                expect(first_question.body).to eq("repl")
            end
        end

        context "when the question's info has not changed" do
            it "does not change anything in the db" do
                first_question.update
                expect(Question.find_by_id(1).body).to eq("I'm pretty sure they're both used for front end development")
            end
        end

        it "does not add or subtract users from the db" do
            first_question.body = "repl"
            expect{first_question.update}.to_not change{Question.all.length}
        end

        it "returns true upon success" do
            expect(first_question.update).to be true
        end
    end

    describe '#get_follows' do
        subject (:q1) {Question.find_by_id(1)}
        it "calls question_follows_full" do
            expect(QuestionFollow).to receive(:question_follows_full).with(1)
            q1.get_follows
        end
    end

    describe '#get_likes' do
        subject (:q1) {Question.find_by_id(1)}
        it "calls question_likers_full" do
            expect(QuestionLike).to receive(:question_likers_full).with(1)
            q1.get_likes
        end
    end

    describe '#num_likes' do
        subject (:q1) {Question.find_by_id(1)}
        it "calls num_likes_for_question_id" do
            expect(QuestionLike).to receive(:num_likes_for_question_id).with(1)
            q1.num_likes
        end
    end

    describe '#get_replies' do
        subject (:q1) {Question.find_by_id(1)}
        it "calls find_by_question_id" do
            expect(Reply).to receive(:find_by_question_id).with(1)
            q1.get_replies
        end
    end

    describe '#get_first_replies' do
        subject (:has_replies) {Question.find_by_id(1)}
        subject (:no_replies) {Question.find_by_id(3)}

        context "when there are no replies" do
            it "returns an empty array" do
                expect(no_replies.get_first_replies).to be_empty
            end
        end

        context "when there are replies" do
            it "returns an array of only the first replies" do
                reps = has_replies.get_first_replies
                expect(reps).to be_an(Array)
                expect(reps).to all(be_a(Reply))
                expect(reps.length).to eq(2)
            end
        end
    end

    describe '#author' do
        subject (:q1) {Question.find_by_id(1)}
        it "returns the User who authored the question" do
            auth = q1.author
            expect(auth).to be_a(User)
            expect(auth.fname).to eq("Christine")
            expect(auth.lname).to eq("Parisi")
        end
    end

    # describe '#remove' do
    #     it "removes the question from the db"
    #     it "removes all likes of the question"
    #     it "removes all follows of the question"
    #     it "removes all replies"
    #     it "removes all likes of those replies"
    # end
end