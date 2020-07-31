describe FeedbackMailer, type: :mailer do
  let(:participant) { create(:participant, name: 'test_participant') }
  let(:feedback)    { create(:feedback, message: '<p>Feedback message</p>', participant: participant) }

  describe '#feedback_email' do
    subject { described_class.feedback_email(feedback) }

    it 'renders the headers' do
      expect(subject.subject).to eq '[test_participant] Feedback about AICrowd'
      expect(subject.to).to eq ['feedback@aicrowd.com']
      expect(subject.from).to eq ['no-reply@aicrowd.com']
    end

    it 'renders the body' do
      expect(subject.body.encoded).to match 'Feedback message'
    end
  end
end
