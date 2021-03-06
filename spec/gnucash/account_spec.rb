module Gnucash
  describe Account do
    before(:all) do
      # just read the file once
      @book = Gnucash.open("spec/books/sample.gnucash")
      @assets = @book.find_account_by_full_name("Assets")
      @checking = @book.find_account_by_full_name("Assets:Current Assets:Checking Account")
      @income = @book.find_account_by_full_name("Income")
      @salary = @book.find_account_by_full_name("Income:Salary")
    end

    it "gives access to the account name" do
      expect(@salary.name).to eq "Salary"
    end

    it "gives access to the account description" do
      expect(@checking.description).to eq "Checking Account"
    end

    it "gives access to the fully-qualified account name" do
      expect(@checking.full_name).to eq "Assets:Current Assets:Checking Account"
    end

    it "gives access to the final balance" do
      expect(@checking.final_balance).to eq Value.new(19743000)
    end

    describe '.balance_on' do
      it "returns 0 if the given date is before the account's first transaction" do
        expect(@checking.balance_on("2006-12-12")).to eq Value.new(0)
      end

      it "returns the final balance if the given date is after the account's last transaction" do
        expect(@checking.balance_on("2013-10-10")).to eq @checking.final_balance
      end

      it "returns the balance on the given date" do
        expect(@checking.balance_on("2012-12-25")).to eq Value.new(19688000)
      end

      it "includes transactions that occur on the given date" do
        expect(@checking.balance_on("2007-03-27")).to eq Value.new(780000)
      end
    end

    it "stores whether the account was a placeholder" do
      expect(@assets.placeholder).to be_truthy
      expect(@checking.placeholder).to be_falsey
      expect(@income.placeholder).to be_truthy
      expect(@salary.placeholder).to be_falsey
    end
  end
end
