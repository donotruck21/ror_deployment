class OnlinelendingController < ApplicationController
  def registerindex
  end

  def loginindex
  end

  def register
    if params[:user_type] == "lender"
        l = Lender.create( first_name: params[:first_name], last_name: params[:last_name], email: params[:email], password: params[:password], money: params[:money] )

        if l.errors.full_messages.empty?
            puts "LENDER SUCCESSFULLY CREATED"
            redirect_to '/onlinelending/loginindex'

        else
            flash[:l_errors] = l.errors.full_messages
            redirect_to '/'
        end

    elsif params[:user_type] == "borrower"
        b = Borrower.create( first_name: params[:first_name], last_name: params[:last_name], email: params[:email], need_money_for: params[:need_money_for], description: params[:description], password: params[:password], amount_needed: params[:amount_needed], amount_raised: 0)

        if b.errors.full_messages.empty?
            puts "BORROWER SUCCESSFULLY CREATED"
            redirect_to '/onlinelending/loginindex'

        else
            flash[:b_errors] = b.errors.full_messages
            redirect_to '/'
        end

    else
        puts "WTF "*100
        redirect_to "/"

    end
  end

  def login
    puts params[:email]
    puts params[:password]

    user = Lender.find_by_email(params[:email])
    if user && user.authenticate(params[:password])
        puts "LENDER IS LOGGED IN"
        session[:user_id] = user.id
        redirect_to "/onlinelending/lenderindex"
    else
        user = Borrower.find_by_email(params[:email])

        if user && user.authenticate(params[:password])
            puts "BORROWER IS LOGGED IN"
            session[:user_id] = user.id
            redirect_to "/onlinelending/borrowerindex"
        else
            flash[:error] = "Invalid Combination"
            redirect_to '/onlinelending/loginindex'
        end
    end
  end

  def borrowerindex
    @borrower = Borrower.find(session[:user_id])
    @all_lends = History.joins(:lender).where(borrower_id: session[:user_id]).select("first_name", "last_name", "email", "amount")
  end

  def lenderindex
    @lender = Lender.find(session[:user_id])
    @all_borrowers = Borrower.all
    @all_lends = History.joins(:borrower).where(lender_id: session[:user_id]).select("first_name", "last_name", "need_money_for", "description", "amount_needed", "amount_raised", "amount", "lender_id")
  end

  def lend
    lend = History.where(borrower: Borrower.find(params[:borrower_id]), lender: session[:user_id])[0]

    lender = Lender.find(session[:user_id])
    borrower = Borrower.find(params[:borrower_id])

    new_total = lender.money - params[:lend_amount].to_i

    b_amount_needed = borrower.amount_needed - params[:lend_amount].to_i
    b_amount_raised = borrower.amount_raised + params[:lend_amount].to_i

    if lend
        puts "ALREADY EXISTS! UPDATE INSTEAD"
        new_lend = lend.amount + params[:lend_amount].to_i
        if new_total > 0
            lender.update(money: new_total)

            if b_amount_needed <= 0
                borrower.update(amount_needed: 0, amount_raised: b_amount_raised)
            else
                borrower.update(amount_needed: b_amount_needed, amount_raised: b_amount_raised)
            end

            lend.update( amount: new_lend )
        else
            flash[:message] = "Insufficient Funds"
        end
        redirect_to "/onlinelending/lenderindex"
    else
        puts "NEW LEND"
        if new_total > 0
            lender.update(money: new_total)

            if b_amount_needed <= 0
                borrower.update(amount_needed: 0, amount_raised: b_amount_raised)
            else
                borrower.update(amount_needed: b_amount_needed, amount_raised: b_amount_raised)
            end

            History.create(borrower: Borrower.find(params[:borrower_id]), lender: Lender.find(session[:user_id]), amount:params[:lend_amount] )
        else
            flash[:message] = "Insufficient Funds"
        end
        redirect_to "/onlinelending/lenderindex"
    end

  end

  def logout
    session.clear()
    redirect_to '/'
  end
end
