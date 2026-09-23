(function (global) {
  "use strict";

  function materialSuffix(itemName) {
    var separator = itemName.lastIndexOf("_");
    return separator === -1 ? itemName : itemName.slice(separator + 1);
  }

  function hitsToBreak(item, equippedCount) {
    if (!item || equippedCount < 1) {
      return null;
    }
    if (item.armorUse === 0) {
      return Infinity;
    }
    var wearPerHit = Math.ceil(item.armorUse / equippedCount);
    return Math.floor(65535 / wearPerHit) + 1;
  }

  function calculateLoadout(selectedItems, sourceData) {
    var data = sourceData || global.SQUAREONE_ARMOR_DATA;
    var config = data.config;
    var items = selectedItems.filter(Boolean);
    var equippedCount = items.length;
    var selectedBySlot = {};
    var rawDefense = 0;
    var rawBlock = 0;
    var fire = 0;
    var jump = 1;
    var speed = 1;
    var gravity = 1;
    var reflect = false;

    items.forEach(function (item) {
      selectedBySlot[item.slot] = item;
      rawDefense += item.defense;
      rawBlock += item.block;
      fire += item.fire;
      jump += item.jump;
      speed += item.speed;
      gravity += item.gravity;
      reflect = reflect || item.reflect;
    });

    var matchingMaterial = null;
    var requiredSlots = config.setSlots || [];
    var hasRequiredSlots = requiredSlots.length > 0 && requiredSlots.every(function (slot) {
      return Boolean(selectedBySlot[slot]);
    });

    if (hasRequiredSlots) {
      var firstMaterial = materialSuffix(selectedBySlot[requiredSlots[0]].item);
      var isMatching = requiredSlots.every(function (slot) {
        return materialSuffix(selectedBySlot[slot].item) === firstMaterial;
      });
      if (isMatching) {
        matchingMaterial = firstMaterial;
      }
    }

    var defense = rawDefense * config.levelMultiplier;
    if (matchingMaterial) {
      defense *= config.setMultiplier;
    }

    var durability = items.map(function (item) {
      return {
        item: item,
        hits: hitsToBreak(item, equippedCount)
      };
    });
    var finiteDurability = durability.map(function (entry) {
      return entry.hits;
    }).filter(Number.isFinite);
    // var firstBreak = finiteDurability.length > 0
    //   ? Math.min.apply(Math, finiteDurability)
    //   : (durability.length > 0 ? Infinity : null);

    return {
      equippedCount: equippedCount,
      rawDefense: rawDefense,
      defense: Math.min(100, defense),
      block: Math.min(100, rawBlock * config.healMultiplier),
      fire: fire,
      jump: jump,
      speed: speed,
      gravity: gravity,
      reflect: reflect,
      matchingMaterial: matchingMaterial,
      durability: durability //,
      // firstBreak: firstBreak
    };
  }

  var calculatorApi = {
    calculateLoadout: calculateLoadout,
    hitsToBreak: hitsToBreak,
    materialSuffix: materialSuffix
  };
  global.SquareOneArmorCalculator = calculatorApi;
  if (typeof module !== "undefined" && module.exports) {
    module.exports = calculatorApi;
  }

  if (typeof document === "undefined") {
    return;
  }

  function formatNumber(value, places) {
    if (value === null) {
      return "—";
    }
    if (value === Infinity) {
      return "Infinite";
    }
    if (Number.isInteger(value)) {
      return String(value);
    }
    return value.toFixed(places).replace(/\.?0+$/, "");
  }

  function formatModifier(value) {
    if (value === 0) {
      return "0";
    }
    return (value > 0 ? "+" : "") + formatNumber(value, 2);
  }

  function setText(id, value) {
    var element = document.getElementById(id);
    if (element) {
      element.textContent = value;
    }
  }

  function addCell(row, value) {
    var cell = document.createElement("td");
    cell.textContent = value;
    row.appendChild(cell);
    return cell;
  }

  function buildReferenceTable(container, data) {
    var table = document.createElement("table");
    table.className = "armor-calculator__reference-table";
    var head = document.createElement("thead");
    var headingRow = document.createElement("tr");
    ["Set", "Piece", "Durability", "Defense", "Block", "Fire", "Speed", "Jump", "Gravity", "Reflect"].forEach(function (heading) {
      var cell = document.createElement("th");
      cell.scope = "col";
      cell.textContent = heading;
      headingRow.appendChild(cell);
    });
    head.appendChild(headingRow);
    table.appendChild(head);

    var body = document.createElement("tbody");
    data.items.forEach(function (item) {
      var row = document.createElement("tr");
      addCell(row, item.setLabel);
      var pieceCell = document.createElement("td");
      var image = document.createElement("img");
      image.src = "/images/textures/armor/" + item.image;
      image.alt = "";
      image.loading = "lazy";
      pieceCell.appendChild(image);
      var label = document.createElement("span");
      label.textContent = item.label;
      pieceCell.appendChild(label);
      row.appendChild(pieceCell);
      addCell(row, formatNumber(hitsToBreak(item, 5), 0));
      addCell(row, formatNumber(item.defense, 2));
      addCell(row, formatNumber(item.block, 2));
      addCell(row, formatNumber(item.fire, 2));
      addCell(row, formatModifier(item.speed));
      addCell(row, formatModifier(item.jump));
      addCell(row, formatModifier(item.gravity));
      addCell(row, item.reflect ? "Yes" : "No");
      body.appendChild(row);
    });
    table.appendChild(body);
    container.appendChild(table);
  }

  function initializeCalculator() {
    var root = document.getElementById("armor-calculator");
    var data = global.SQUAREONE_ARMOR_DATA;
    if (!root || !data) {
      return;
    }

    var lookup = {};
    var bySet = {};
    data.items.forEach(function (item) {
      lookup[item.item] = item;
      bySet[item.set] = bySet[item.set] || [];
      bySet[item.set].push(item);
    });

    var slotLabels = {
      helmet: "Helmet",
      chestplate: "Chestplate",
      leggings: "Leggings",
      boots: "Boots",
      shield: "Shield"
    };
    var placeholderImages = {
      helmet: "3d_armor_inv_helmet_steel.png",
      chestplate: "3d_armor_inv_chestplate_steel.png",
      leggings: "3d_armor_inv_leggings_steel.png",
      boots: "3d_armor_inv_boots_steel.png",
      shield: "shields_inv_shield_steel.png"
    };
    var slotsContainer = document.getElementById("armor-calculator-slots");
    var selects = {};
    var previews = {};

    data.config.slots.forEach(function (slot) {
      var control = document.createElement("div");
      control.className = "armor-calculator__slot";
      var image = document.createElement("img");
      image.alt = "";
      image.src = "/images/textures/armor/" + placeholderImages[slot];
      image.classList.add("armor-calculator__placeholder");
      control.appendChild(image);
      previews[slot] = image;

      var label = document.createElement("label");
      label.htmlFor = "armor-slot-" + slot;
      label.textContent = slotLabels[slot];
      control.appendChild(label);

      var select = document.createElement("select");
      select.id = "armor-slot-" + slot;
      select.dataset.slot = slot;
      var emptyOption = document.createElement("option");
      emptyOption.value = "";
      emptyOption.textContent = "None";
      select.appendChild(emptyOption);

      data.items.filter(function (item) {
        return item.slot === slot;
      }).sort(function (left, right) {
        return left.setLabel.localeCompare(right.setLabel);
      }).forEach(function (item) {
        var option = document.createElement("option");
        option.value = item.item;
        option.textContent = item.setLabel;
        select.appendChild(option);
      });
      control.appendChild(select);
      slotsContainer.appendChild(control);
      selects[slot] = select;
    });

    var preset = document.getElementById("armor-calculator-preset");
    Object.keys(bySet).sort().forEach(function (setName) {
      var setItems = bySet[setName];
      var isComplete = data.config.slots.every(function (slot) {
        return setItems.some(function (item) {
          return item.slot === slot;
        });
      });
      if (isComplete) {
        var option = document.createElement("option");
        option.value = setName;
        option.textContent = setItems[0].setLabel;
        preset.appendChild(option);
      }
    });

    function render() {
      var selected = data.config.slots.map(function (slot) {
        return lookup[selects[slot].value] || null;
      }).filter(Boolean);
      var result = calculateLoadout(selected, data);

      data.config.slots.forEach(function (slot) {
        var item = lookup[selects[slot].value];
        var preview = previews[slot];
        if (item && item.image) {
          preview.src = "/images/textures/armor/" + item.image;
          preview.alt = item.label;
          preview.classList.remove("armor-calculator__placeholder");
        } else {
          preview.src = "/images/textures/armor/" + placeholderImages[slot];
          preview.alt = "";
          preview.classList.add("armor-calculator__placeholder");
        }
      });

      setText("armor-result-defense", formatNumber(result.defense, 2) + "%");
      setText("armor-result-block", formatNumber(result.block, 2) + "%");
      setText("armor-result-fire", formatNumber(result.fire, 2));
      setText("armor-result-speed", formatNumber(result.speed, 2) + "×");
      setText("armor-result-jump", formatNumber(result.jump, 2) + "×");
      setText("armor-result-gravity", formatNumber(result.gravity, 2) + "×");
      setText("armor-result-reflect", result.reflect ? "Yes" : "No");
      // setText("armor-result-first-break", formatNumber(result.firstBreak, 0));
      setText("armor-result-set", result.matchingMaterial ? "Yes" : "No");
      setText("armor-durability-context", result.equippedCount === 0
        ? "Select armor to calculate durability."
        : "Using " + result.equippedCount + " equipped armor element" + (result.equippedCount === 1 ? "." : "s."));

      var durabilityList = document.getElementById("armor-result-durability");
      durabilityList.textContent = "";
      result.durability.forEach(function (entry) {
        var listItem = document.createElement("li");
        listItem.textContent = entry.item.label + ": " + formatNumber(entry.hits, 0);
        durabilityList.appendChild(listItem);
      });
    }

    Object.keys(selects).forEach(function (slot) {
      selects[slot].addEventListener("change", function () {
        preset.value = "";
        render();
      });
    });

    preset.addEventListener("change", function () {
      var setItems = bySet[preset.value] || [];
      data.config.slots.forEach(function (slot) {
        var item = setItems.find(function (candidate) {
          return candidate.slot === slot;
        });
        selects[slot].value = item ? item.item : "";
      });
      render();
    });

    document.getElementById("armor-calculator-reset").addEventListener("click", function () {
      preset.value = "";
      data.config.slots.forEach(function (slot) {
        selects[slot].value = "";
      });
      render();
    });

    buildReferenceTable(document.getElementById("armor-reference-table"), data);
    render();
  }

  if (document.readyState === "loading") {
    document.addEventListener("DOMContentLoaded", initializeCalculator);
  } else {
    initializeCalculator();
  }
}(typeof window !== "undefined" ? window : globalThis));
