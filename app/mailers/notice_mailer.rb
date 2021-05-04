class NoticeMailer < ApplicationMailer
  def send_favorited_your_book(user, book)
    @user = user
    @book = book
    mail to: user.email, subject: '[Notice] your book is favorited'
  end
end
