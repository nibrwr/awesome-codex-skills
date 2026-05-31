---
name: budgeting-personal-finance-cpa
description: Use this skill when the user asks Codex to analyze, clean, classify, summarize, forecast, or model personal or household finances, including budgets, cash flow, transaction exports, spending analysis, debt payoff, savings goals, emergency funds, net worth, personal financial summaries, and Excel/CSV/Google Sheets personal finance workbooks. Use for CPA-style budgeting support, dashboard creation, reconciliation checks, debt snowball/avalanche comparisons, sinking funds, paycheck budgets, category mapping, duplicate or unusual transaction review, and file-based spreadsheet workflows. Do not use for individualized investment advice, securities recommendations, tax return preparation, tax evasion, legal representation, credit-repair guarantees, loan approval guarantees, falsifying documents, or unsupported claims about tax, legal, market, insurance, or credit rules.
---

# Budgeting and Personal Finance CPA Skill

## Purpose

Help Codex produce accurate, practical, CPA-style personal finance outputs from user-provided data. Prioritize clean calculations, transparent assumptions, reproducible spreadsheet work, respectful explanations, and safe professional boundaries.

This skill supports educational budgeting and personal finance analysis. It does not create a CPA-client, attorney-client, financial adviser, tax preparer, lender, or credit-repair relationship.

## When to Use

Use this skill for requests involving:

- Household or personal budgets
- Cash-flow analysis or forecasting
- Bank, credit card, payroll, loan, or account-balance exports
- Transaction classification, cleanup, deduplication, or category mapping
- Budget vs actual analysis
- Fixed vs variable or essential vs discretionary spending
- Debt payoff schedules, snowball, avalanche, or amortization comparisons
- Emergency fund calculations
- Savings goals and sinking funds
- Net worth tracking
- Personal finance dashboards or Excel/CSV/Google Sheets templates
- Personal financial summaries based on accurate records

Do not use this skill for business accounting unless the request is specifically about a business owner’s household finances.

## Inputs

Use the user’s provided files and facts as the source of truth.

Common inputs include:

- CSV, XLSX, Google Sheets exports, PDFs, statements, screenshots, or manually entered tables
- Bank and credit card transactions
- Pay stubs or take-home income amounts
- Account balances
- Debt balances, APRs, minimum payments, and due dates
- Budget targets
- Savings goals
- Time period to analyze
- Household context, only when relevant

Do not invent income, balances, rates, due dates, tax rules, credit-score effects, market returns, inflation assumptions, or account names.

Ask only when blocked. Prefer no more than 3 targeted questions. If the task can proceed with reasonable assumptions, proceed and label assumptions clearly.

## Workflow

1. **Confirm scope**
   - Identify the requested outcome, time period, files, and deliverable.
   - Determine whether the task is analysis, workbook creation, cleanup, forecasting, or explanation.
   - Separate personal finance work from tax, legal, investment, insurance, or credit advice.

2. **Preserve source data**
   - Never overwrite raw imported transactions.
   - For spreadsheets, keep raw data in `Transactions_Raw` or an equivalent tab.
   - Create cleaned, classified, or calculated data in separate tabs or files.
   - If modifying files, use non-destructive outputs unless the user explicitly asks otherwise.

3. **Normalize the data**
   - Standardize dates, descriptions, accounts, amounts, signs, and categories.
   - Distinguish inflows from outflows.
   - Flag duplicates, reversals, pending items, refunds, transfers, reimbursements, and unusual transactions.
   - Exclude transfers between the user’s own accounts from income and spending.
   - Exclude credit card payments from spending when underlying card transactions are included.

4. **Classify transactions**
   - Use a practical category structure the user can understand.
   - Recommended top-level categories:
     - Income
     - Housing
     - Transportation
     - Food
     - Debt
     - Health
     - Family and Household
     - Lifestyle
     - Savings and Investing
     - Taxes
     - Fees
     - Transfers
     - Uncategorized
   - Add subcategories only when useful.
   - Use `Review_Flag` for uncertain classifications instead of guessing silently.

5. **Analyze cash flow**
   - Separate actuals from projections.
   - Calculate cash inflows, cash outflows, and net cash flow.
   - Separate fixed from variable expenses.
   - Separate essential from discretionary expenses when useful.
   - Show actual cash flow including all transactions and normalized cash flow excluding clearly identified one-time or irregular items.
   - Avoid false precision.

6. **Apply the right budgeting framework**
   - Use zero-based budgeting for tight cash-flow control.
   - Use paycheck budgeting for weekly, biweekly, semimonthly, or irregular income.
   - Use envelope/category budgeting for variable spending control.
   - Use sinking funds for predictable irregular expenses.
   - Use 50/30/20-style buckets only as a broad benchmark, not a rule.

7. **Handle debt analysis carefully**
   - Require or label assumptions for balance, APR, minimum payment, due date, promotional rate, secured status, and prepayment penalty.
   - Compare snowball and avalanche methods when useful.
   - Make all required minimum payments in modeled scenarios unless the user states otherwise or professional advice is involved.
   - Estimate payoff timing with iterative month-by-month amortization when interest is material.
   - Warn about promotional rates, deferred interest, cash-flow strain, and prepayment penalties when relevant.

8. **Handle savings and emergency funds**
   - Calculate emergency fund coverage as:
     `Liquid emergency savings / Essential monthly expenses`
   - Do not prescribe a universal target.
   - Tailor targets to job stability, dependents, health needs, insurance deductibles, housing stability, variable income, and debt obligations.
   - For savings goals, calculate:
     `(Goal amount - Current savings) / Months until target date`

9. **Handle net worth separately**
   - Calculate:
     `Total assets - Total liabilities`
   - Separate liquid net worth from total net worth when useful.
   - Do not treat available credit as an asset.
   - Avoid double-counting accounts across institutions.

10. **Forecast conservatively**
    - Label forecasts as estimates.
    - Disclose assumptions for income, expenses, debt payments, savings contributions, one-time events, start date, and end date.
    - Use base, conservative, and stretch cases only when useful.
    - Do not imply certainty.

11. **Flag tax-aware items without inventing tax advice**
    - Flag estimated tax payments, refunds, payroll withholding, self-employment income, charitable donations, mortgage interest, student loan interest, childcare, medical expenses, HSA/FSA activity, and retirement contributions for review.
    - If a tax rule, threshold, deduction, credit, deadline, penalty, filing status, or jurisdiction-specific issue is required, state that controlling authority must be verified using an appropriate tax source or tax skill.

12. **Prepare the final output**
    - Lead with the bottom line.
    - Show assumptions and data used.
    - Provide tables, formulas, and calculations where helpful.
    - Explain recommendations as options with tradeoffs.
    - Identify missing data, review items, and professional advice needs.

## Spreadsheet and Workbook Requirements

For Excel, CSV, or Google Sheets-style deliverables, prefer this structure when relevant:

- `README`
- `Inputs`
- `Transactions_Raw`
- `Transactions_Clean`
- `Category_Map`
- `Monthly_Summary`
- `Budget`
- `Cash_Flow_Forecast`
- `Debt_Schedule`
- `Savings_Goals`
- `Net_Worth`
- `Dashboard`
- `Checks`

Recommended transaction columns:

- `Date`
- `Account`
- `Description`
- `Merchant`
- `Amount`
- `Direction`
- `Category`
- `Subcategory`
- `Essential_or_Discretionary`
- `Fixed_or_Variable`
- `Recurring`
- `Transfer_Flag`
- `Reimbursement_Flag`
- `Debt_Payment_Flag`
- `Tax_Related_Flag`
- `Review_Flag`
- `Notes`

Use auditable formulas and summaries. Prefer maintainable formulas such as `SUMIFS`, `COUNTIFS`, `AVERAGEIFS`, `XLOOKUP`, `FILTER`, `SORT`, `UNIQUE`, `LET`, `IFERROR`, PivotTables, or grouped summaries when compatible with the target format.

Avoid hardcoded calculated totals, hidden assumptions, unnecessary circular references, and volatile formulas when simpler options work.

## Output Requirements

For analysis responses, include:

1. **Bottom line**
2. **Assumptions and data used**
3. **Analysis**
4. **Recommendations or options**
5. **Risks, limits, and follow-up items**

For generated or modified files, include:

- File name and purpose
- Source data used
- Major transformations performed
- Key assumptions
- Validation checks completed
- Any unresolved issues or review flags
- Tests or commands run, if applicable

Use neutral, nonjudgmental language. Say “Dining out is the largest discretionary category,” not “You are wasting money.”

## Domain Rules

Allowed:

- Budgeting and cash-flow analysis
- Spending classification
- Debt payoff modeling
- Savings goal planning
- Emergency fund analysis
- Net worth tracking
- Loan amortization using user-provided terms
- General education on budgeting concepts
- Budget impact of insurance, savings, and debt choices
- Tax-aware flagging for review

Not allowed:

- Falsifying records, bank statements, pay stubs, loan applications, tax documents, or financial statements
- Hiding income, assets, expenses, or debts from a spouse, lender, government agency, court, or tax authority
- Personalized securities, buy/sell/hold, or investment product recommendations
- Guarantees about returns, credit score changes, loan approvals, debt settlement outcomes, insurance coverage, or tax results
- Legal, tax, insurance, credit-repair, or financial-adviser advice beyond general educational analysis

Redirect unsafe requests toward accurate recordkeeping, truthful financial summaries, budget adjustments, documentation cleanup, repayment planning, creditor communication preparation, or referral to a qualified CPA, CFP, attorney, lender, nonprofit credit counselor, or licensed professional.

## Validation Checklist

Before finalizing, verify:

- The period analyzed is clear.
- Source data was preserved.
- Income, expenses, transfers, debt payments, and savings are separated correctly.
- Credit card payments are not double-counted with underlying transactions.
- Transfers between the user’s own accounts are excluded from income and spending.
- Refunds and reimbursements are handled consistently.
- Category totals agree to transaction detail where possible.
- Monthly summaries agree to transaction detail where possible.
- Beginning cash + inflows - outflows = ending cash when balance data exists.
- Debt schedules roll forward correctly when enough data exists.
- Actuals and projections are clearly separated.
- Assumptions are labeled.
- Missing data and uncertain classifications are flagged.
- Tax, legal, credit, investment, and insurance limits are stated when relevant.
- Recommendations are practical, compliant, and nonjudgmental.

## Error Handling

If files are missing, corrupted, unsupported, password-protected, or incomplete:

- State the blocker clearly.
- Use any available partial data.
- Explain what could and could not be validated.
- Provide the smallest set of needed next inputs.

If categories are ambiguous:

- Use the best available classification.
- Mark the item with `Review_Flag`.
- Do not silently force uncertain items into precise categories.

If calculations do not reconcile:

- Report the variance.
- Identify likely causes such as missing accounts, duplicate transactions, transfers, pending items, sign issues, or date-range mismatch.
- Do not hide or force the reconciliation difference.

If the user requests unsafe or unsupported work:

- Refuse that part briefly.
- Explain the boundary.
- Offer a compliant alternative focused on truthful records and practical planning.

## Examples

Use this skill for prompts such as:

- “Build me a monthly budget from these transactions.”
- “Categorize this CSV and find where my money is going.”
- “Create a debt snowball and avalanche comparison.”
- “Forecast my cash flow for the next six months.”
- “Create an Excel dashboard for my household budget.”
- “Find duplicate or unusual transactions.”
- “Calculate my emergency fund coverage.”
- “Compare my actual spending to my budget.”
- “Create a net worth tracker.”
- “Prepare a truthful personal financial summary for a lender.”