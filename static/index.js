const configForm = document.getElementById("config-form");

function updateSettings() {
    const configFormData = new FormData(configForm);

    fetch("/get-config", {
        method: "POST",
        body: configFormData
    })
    .then(response => response.json())
    .then(data => {
        console.log("Settings updated successfully:", data);
    })
    .catch(error => {
        console.error("Error updating settings:", error);
    });
}

function saveSettings() {
    updateSettings();
    const configFormData = new FormData(configForm);

    fetch("/save-config", {
        method: "POST",
        body: configFormData
    })
    .then(response => response.json())
    .then(data => {
        console.log("Successfully saved settings:", data);
    })
    .catch(error => {
        console.error("Error saving settings:", error);
    });
}

const inputs = configForm.querySelectorAll("input, select, textarea");
inputs.forEach(input => {
    input.addEventListener("change", updateSettings)
})

configForm.addEventListener("keydown", function(event) {
    if (event.key === "Enter") {
        event.preventDefault();
    }
});

document.getElementById("save-settings").addEventListener("click", saveSettings)

document.getElementById("clips-folder-button").addEventListener("click", () => {
    fetch("/open-clips-folder")
    .then(response => {
        if (response.ok) {
            console.log("Folder successfully opened.");
        } else {
            console.error("Failed to open folder.")
        };
    });
});

document.addEventListener("DOMContentLoaded", function() {
    const valueContainers = document.querySelectorAll(".value-container");

    valueContainers.forEach(container => {
        const numberInput = container.querySelector("input[type='number']");
        const rangeInput = container.querySelector("input[type='range']")

        if (!numberInput || !rangeInput) return;

        function enforceConstraints (input) {
            const min = parseFloat(input.min);
            const max = parseFloat(input.max);
            let value = parseFloat(input.value);

            if (isNaN(value)) {
                value = min;
            } else if (value < min) {
                value = min;
            } else if (value > max) {
                value = max;
            }

            input.value = value;
        }

        function syncInputs(source, target) {
            target.value = source.value
        }

        numberInput.addEventListener("input", function () {
            syncInputs(numberInput, rangeInput);
        });

        rangeInput.addEventListener("input", function () {
            syncInputs(rangeInput, numberInput);
        });

        numberInput.addEventListener("blur", function () {
            enforceConstraints(numberInput);
            syncInputs(numberInput, rangeInput);
        });
    });
});