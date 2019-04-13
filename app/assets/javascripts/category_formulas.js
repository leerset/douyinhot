function calculate()
{
    let inputX = document.getElementById('calculate_x');
    let inputResult = document.getElementById('calculate_result');
    let category_formula_formula = document.getElementById('category_formula_formula');
    let x = parseInt(inputX.value) || 0;
    let formula = category_formula_formula.value || '';
    inputResult.value = eval(formula);
}
