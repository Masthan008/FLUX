# Quick Reference - Update 45

## 🔬 C Programming Lab (31 Programs)

### New Programs (15)
| # | Program | Category | Key Concept |
|---|---------|----------|-------------|
| 17 | Linear Search | Search | Array traversal |
| 18 | Selection Sort | Sorting | Min element selection |
| 19 | Insertion Sort | Sorting | Element insertion |
| 20 | Matrix Addition | Matrix | 2D array operations |
| 21 | Matrix Transpose | Matrix | Row-column swap |
| 22 | String Length | Strings | Manual counting |
| 23 | String Concatenation | Strings | Array manipulation |
| 24 | String Compare | Strings | Character comparison |
| 25 | Vowel Counter | Strings | Character checking |
| 26 | Decimal to Binary | Conversion | Base conversion |
| 27 | Binary to Decimal | Conversion | Power calculation |
| 28 | Tower of Hanoi | Recursion | Classic puzzle |
| 29 | Perfect Number | Numbers | Divisor sum |
| 30 | Strong Number | Numbers | Factorial sum |
| 31 | Leap Year | Logic | Date validation |

---

## 🧮 Calculator Pro (9 Tabs)

### Tab 7: Percentage Calculator
```
Functions:
• X% of Y = Result
• X is what % of Y = Result%
• Increase by X% = Higher value
• Decrease by X% = Lower value

Example:
15% of 200 = 30
50 is 25% of 200
200 + 15% = 230
200 - 15% = 170
```

### Tab 8: Tip Calculator
```
Inputs:
• Bill Amount: $50.00
• Tip %: 15% (slider or presets)
• Split: 2 people

Outputs:
• Tip: $7.50
• Total: $57.50
• Per Person: $28.75

Presets: 10%, 15%, 18%, 20%, 25%
```

### Tab 9: Loan Calculator
```
Inputs:
• Loan Amount: $20,000
• Interest Rate: 5% annual
• Term: 5 years

Outputs:
• Monthly Payment: $377.42
• Total Payment: $22,645.48
• Total Interest: $2,645.48
• Payments: 60

Formula: M = P[r(1+r)^n]/[(1+r)^n-1]
```

---

## ⏰ Alarm Features

### History Tracking
```
Actions Logged:
✓ Alarm Created
✓ Alarm Deleted
✓ Alarm Dismissed
✓ Alarm Snoozed

History Entry Format:
{
  title: "Alarm Deleted",
  time: "07:30",
  action: "Deleted",
  timestamp: "2025-11-30T08:15:00"
}

Storage: Hive box 'alarm_history'
Capacity: Last 50 entries
```

### Button Layout
```
[History] [Power Nap] [+]
  Gray      Amber    Purple

History: View alarm history
Power Nap: Quick 20-min alarm
+: Create new alarm
```

---

## 📱 Quick Actions

### C Programming Lab
1. Open app → Navigate to C Code Lab
2. Browse 31 programs by category
3. Tap program to view code
4. Copy code or view output
5. Run in compiler to test

### Calculator - Percentage
1. Open Calculator → Swipe to Percent tab
2. Enter percentage and value
3. See instant results
4. View increase/decrease options

### Calculator - Tip
1. Open Calculator → Swipe to Tip tab
2. Enter bill amount
3. Adjust tip % (slider or presets)
4. Set split count
5. See per-person amount

### Calculator - Loan
1. Open Calculator → Swipe to Loan tab
2. Enter loan amount
3. Enter interest rate
4. Enter term in years
5. View monthly payment and breakdown

### Alarm History
1. Open Alarm screen
2. Tap History button (gray)
3. View all alarm actions
4. Tap "Clear All" to reset
5. Close modal when done

---

## 🎯 Pro Tips

### C Programming
- Programs are organized by difficulty
- Each includes expected output
- Great for exam preparation
- Copy-paste friendly format

### Calculator
- Swipe between tabs for quick access
- All calculations are real-time
- No "Calculate" button needed (except Equation)
- Results update as you type

### Percentage Calculator
- Use for discounts, taxes, tips
- Shows both increase and decrease
- Perfect for shopping calculations

### Tip Calculator
- Presets for common tip percentages
- Split bill feature for groups
- Rounds to 2 decimal places

### Loan Calculator
- Compare different loan terms
- See total interest paid
- Visual breakdown of principal vs interest
- Useful for mortgages, car loans, personal loans

### Alarm History
- Track your alarm habits
- Debug alarm issues
- See snooze patterns
- Privacy-friendly (local storage)

---

## 🔢 Formulas Reference

### Percentage
```
X% of Y = (X/100) × Y
X is what % of Y = (X/Y) × 100
Increase = Y + (Y × X/100)
Decrease = Y - (Y × X/100)
```

### Tip
```
Tip Amount = Bill × (Tip%/100)
Total = Bill + Tip Amount
Per Person = Total / Split Count
```

### Loan (Monthly Payment)
```
M = P × [r(1+r)^n] / [(1+r)^n - 1]

Where:
M = Monthly payment
P = Principal (loan amount)
r = Monthly interest rate (annual rate / 12 / 100)
n = Number of payments (years × 12)
```

### BMI (Existing)
```
Metric: BMI = weight(kg) / [height(m)]²
Imperial: BMI = [weight(lb) / height(in)²] × 703
```

---

## 🎨 Color Coding

### Calculator
- **Cyan Accent**: Primary actions, results
- **Orange**: Operators, special functions
- **Green**: Positive results (increase, normal BMI)
- **Red**: Negative results (decrease, delete)
- **Gray**: Secondary buttons, backgrounds

### Alarm
- **Red Icon**: Deleted alarms
- **Green Icon**: Dismissed alarms
- **Orange Icon**: Snoozed alarms
- **Amber**: Power Nap button
- **Purple**: Add Alarm button
- **Gray**: History button

---

## 📊 Keyboard Shortcuts

### Calculator Input
- Numbers: 0-9
- Operators: +, -, ×, ÷
- Decimal: .
- Clear: AC
- Delete: DEL
- Equals: =

### Scientific Functions
- sin, cos, tan (trigonometry)
- log, ln (logarithms)
- √ (square root)
- ^ (power)
- π, e (constants)

---

## 🐛 Troubleshooting

### Calculator Issues
**Problem**: Result shows "Error"
**Solution**: Check for:
- Division by zero
- Invalid expressions
- Missing parentheses

**Problem**: Percentage not calculating
**Solution**: Ensure both fields have values

### Alarm History Issues
**Problem**: History not showing
**Solution**: 
- Create/delete an alarm to generate history
- Check if history was cleared

**Problem**: History too long
**Solution**: Tap "Clear All" to reset

### C Program Display
**Problem**: Code not visible
**Solution**: Scroll within the code view

---

## 📱 Screen Navigation

```
Home Screen
├── Calculator Pro
│   ├── Tab 1: Scientific Calc
│   ├── Tab 2: Unit Converter
│   ├── Tab 3: CGPA Calculator
│   ├── Tab 4: BMI Calculator
│   ├── Tab 5: Age Calculator
│   ├── Tab 6: Equation Solver
│   ├── Tab 7: Percentage ⭐ NEW
│   ├── Tab 8: Tip Calculator ⭐ NEW
│   └── Tab 9: Loan Calculator ⭐ NEW
│
├── C Code Lab
│   └── 31 Programs (15 new) ⭐
│
└── Alarm
    ├── Alarm List
    ├── History Button ⭐ NEW
    ├── Power Nap Button
    └── Add Alarm Button
```

---

## 💡 Use Cases

### For Students
- **C Lab**: Learn programming concepts
- **Calculator**: Solve math problems
- **CGPA**: Track academic performance
- **Alarm**: Wake up for classes

### For Professionals
- **Loan Calculator**: Financial planning
- **Tip Calculator**: Dining out
- **Unit Converter**: Work calculations
- **Alarm**: Meeting reminders

### For Everyone
- **BMI**: Health tracking
- **Age Calculator**: Birthday calculations
- **Percentage**: Shopping discounts
- **Equation Solver**: Quick math

---

## 🎓 Learning Path

### Beginner (C Programming)
1. Hello World
2. Variables & Data Types
3. Loops (Fibonacci, Factorial)
4. Arrays (Sum, Average, Largest)

### Intermediate
5. Sorting (Bubble, Selection, Insertion)
6. Searching (Linear, Binary)
7. Strings (Length, Reverse, Compare)
8. Matrix Operations

### Advanced
9. Recursion (Power, Tower of Hanoi)
10. Pointers
11. Number Theory (Prime, Armstrong, Perfect)
12. Algorithms (GCD/LCM)

---

## 🔐 Privacy & Data

### Local Storage Only
- Alarm history: Stored in Hive
- Calculator history: In-memory only
- No cloud sync
- No data collection
- No internet required

### Data Management
- Clear alarm history anytime
- Calculator results not saved
- C programs are read-only
- All data stays on device

---

**Quick Reference Complete - Happy Coding! 🚀**
