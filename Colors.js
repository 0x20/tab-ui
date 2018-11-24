.pragma library

// Color order is
// 0: base
// 1: very dark
// 2: dark
// 3: light
// 4: very light

var primary = [
  "#032542",
  "#04182A",
  "#031C33",
  "#063864",
  "#074B89",
];
var secondary1 = [
  "#672000",
  "#411502",
  "#4F1900",
  "#9B3000",
  "#D34200",
];
var secondary2 = [
  "#00452B",
  "#012C1C",
  "#003521",
  "#006941",
  "#008F59",
];
var complement = [
  "#673C00",
  "#412702",
  "#4F2E00",
  "#9B5B00",
  "#D37C00",
];

var gray = (function() {
    var result = [];
    for (var i = 0; i < primary.length; i++) {
        result.push(Qt.hsva(0,0, Qt.lighter(primary[i], 1.0).hsvValue, 1));
    }
    return result;
})();
