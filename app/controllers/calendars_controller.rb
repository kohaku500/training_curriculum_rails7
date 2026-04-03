class CalendarsController < ApplicationController

  # １週間のカレンダーと予定が表示されるページ
  def index
    get_week
    @plan = Plan.new
  end

  # 予定の保存
  def create
    Plan.create(plan_params)
    redirect_to action: :index
  end

  private

  def plan_params
    params.require(:plan).permit(:date, :plan)
  end

  def get_week
    wdays = ['(日)','(月)','(火)','(水)','(木)','(金)','(土)']

    # Dateオブジェクトは、日付を保持しています。下記のように`.today.day`とすると、今日の日付を取得できます。
    @today = Date.today
    # 例)　今日が2月1日の場合・・・ Date.today.day => 1日

    @week_days = []

    plans = Plan.where(date: @today..(@today + 6)).group_by(&:date)

    7.times do |x|
      current_date = @today + x
      today_plans = plans[current_date]&.map(&:plan) || []
      wday_num = current_date.wday
      days = { month: current_date.month, date: current_date.day, plans: today_plans, wday: wdays[wday_num] }
      @week_days.push(days)
    end

  end
end
