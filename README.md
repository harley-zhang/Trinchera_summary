# Trinchera Ranch Summary Statistics

<div>
 <img src="https://img.shields.io/badge/R-%23276DC3.svg?style=for-the-badge&logo=R&logoColor=white"/>
 <br><br>
</div>
  
 Using R to summarize relevant 2022 and 2023 survey statistics for Trinchera Ranch, a 172,000-acre conservation area in Fort Garland, Colorado. Developed with the Yale School of the Environment. Uses dplyr, tidyr, and stringr.

To clone this repository:

    git clone https://github.com/harley-zhang/Trinchera_summary

<br>

## Plot Statistics

### Treatment Statistics:
- **Treatment year:** The year each plot was treated.
- **Treatment type:** Types of treatment used within a plot.

### Tree Statistics:
- **Basal area per acre:** Calculates basal area in inches per acre for living trees.
- **Average diameter at breast height (DBH):** Calculates the average DBH in inches per acre for living trees.
- **Average height:** Calculates the average height in feet for living trees.
- **Dominant tree species:** Identifies the dominant tree species per plot, considering survey, frequency, and if the dominant one is less than or equal to 50% frequency, also determines the second-dominant tree species.

### Regeneration Statistics:
- **Regeneration presence:** Checks if regeneration (saplings or seedlings) is present in each plot.
- **Seedlings per acre:** Calculates the number of seedlings per acre.
- **Dominant regeneration species:** Identifies the dominant regeneration (sapling/seedling) species per plot, considering survey, frequency, and if the dominant one is less than or equal to 50% frequency, also determines the second-dominant regeneration species.

### Damage Statistics:
- **Insect presence:** Determines if insect damage is present in each plot (Y/N).
- **Browse presence:** Identifies if browse damage is present in each plot (Y/N).
- **List of damage types:** Lists each type of damage present in each plot.

<br>

## Forest Stand Statistics

### Tree Statistics:
- **Basal area per acre:** Calculates basal area in inches per acre for living trees.
- **Average diameter at breast height (DBH):** Calculates the average DBH in inches per acre for living trees.
- **Average height:** Calculates the average height in feet for living trees.
- **Dominant tree species:** Identifies the dominant tree species in each stand and calculates the number and percent of plots.

### Regeneration Statistics:
- **Regeneration presence:** Calculates the number and percent of plots with regeneration (saplings or seedlings) in each stand.
- **Seedlings per acre:** Calculates the average number of seedlings per acre in each stand.
- **Dominant regeneration species:** Identifies the dominant regeneration (sapling/seedling) species in each stand and calculates the number and percent of plots.

### Damage Statistics:
- **Insect damage presence::** Calculates the number and percent of plots with insect damage in each stand.
- **Browse damage presence::** Calculates the number and percent of plots with browsing damage in each stand.
- **List of damage types:** Lists all damage present across all plots within a stand.
