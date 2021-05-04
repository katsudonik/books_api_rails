require "rails_helper"

RSpec.describe NoticeMailer, type: :mailer do
  describe '#send_favorited_your_book' do
    let!(:book) { create(:book) }

    subject(:mail) do
      described_class.send_favorited_your_book(book.user, book).deliver_now
      ActionMailer::Base.deliveries.last
    end

    context 'when send_mail' do
      it { expect(mail.from.first).to eq(ENV.fetch('SMTP_USERNAME')) }
      it { expect(mail.to.first).to eq(book.user.email) }
      it { expect(mail.subject).to eq('[Notice] your book is favorited') }
      it { expect(mail.body).to match("Dear #{book.user.name}:") }
      it { expect(mail.body).to match("your book `#{book.title}` is favorited.") }
    end
  end
end
