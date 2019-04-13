function calculate()
{
    var inputX = document.getElementById('calculate_x');
    var inputResult = document.getElementById('calculate_result');
    var category_formula_formula = document.getElementById('category_formula_formula');
    var x = parseFloat(inputX.value) || 0;
    var formula = category_formula_formula.value || '';
    inputResult.value = eval(formula).toFixed(10);
}
