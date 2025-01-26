# 2D-Optical-Tomography
** Project title:Stochastic Modeling and Simulation of Diffuse Optical Tomography for Hemorrhage Detection in Infant Brains**

**Abstract**

Diffuse Optical Tomography (DOT) is a non-invasive imaging technique that uses near-infrared light to create functional images of biological tissues, offering a safer and more cost-effective alternative to traditional imaging methods like X-rays and MRI. This project focuses on the stochastic modeling and simulation of photon migration in DOT, specifically for the detection of hemorrhagic lesions in infant brains. By employing a Monte Carlo simulation approach, the study models the propagation of photons through a simplified two-dimensional representation of an infant's head, incorporating a circular inclusion to represent a hemorrhagic lesion with distinct optical properties. The simulation tracks individual photons as they scatter and are absorbed within the tissue, using the Henyey-Greenstein distribution to model anisotropic scattering behavior. The study examines how variations in absorption coefficients (μ₁ and μ₂) within and outside the lesion affect photon migration, absorption, and exit points. Graphical analyses of photon paths, absorption points, and exit distributions provide insights into the spatial sensitivity of DOT and its ability to detect abnormalities. Key findings include the demonstration that higher absorption within the lesion leads to increased photon absorption and fewer photons escaping the boundary, aligning with biological expectations. The study also highlights the importance of spatial sensitivity in optimizing source and detector placement for effective image reconstruction. The results suggest that DOT can effectively differentiate between healthy tissue and hemorrhagic lesions, making it a promising tool for non-invasive brain imaging in infants.The project concludes with implications for healthcare, emphasizing DOT's potential for early detection of brain hemorrhages, cost-effectiveness, and functional imaging capabilities. Future work is proposed to extend the simulation to three-dimensional models, incorporate more complex tissue structures, and validate the findings through experimental studies. Overall, this project contributes to the advancement of DOT as a reliable and accessible diagnostic tool in medical imaging.


 **SUMMARY**
1.Photon Absorption and Escape: Higher absorption coefficients (μ₁) within the hemorrhagic lesion lead to increased photon absorption, resulting in fewer photons escaping the boundary. This behavior aligns with biological expectations, as blood absorbs more light than healthy tissue.

2. Photon Paths and Exit Points: Photons that are absorbed are predominantly found within the lesion region when μ₁ > μ₂, confirming the lesion's significant impact on light distribution. Photons that escape provide information about which areas of the boundary are more likely to receive transmitted light, depending on the lesion's presence.

3. Spatial Sensitivity: The spatial sensitivity analysis reveals that scattering points and photon paths are concentrated along the direct path between the source and receiver. This indicates that the system is highly sensitive to regions along this path, which is crucial for detecting abnormalities like hemorrhagic lesions.

4. Impact of Inclusion on Photon Exit Patterns: The presence of the hemorrhagic inclusion significantly alters the distribution of photon exits, with fewer photons detected near the lesion due to higher absorption. This effect is visualized through heatmaps and difference matrices, highlighting the inclusion's impact on light propagation.

5. Henyey-Greenstein Scattering Model: The use of the Henyey-Greenstein distribution effectively captures the forward-scattering behavior of photons in biological tissues, which is critical for accurately modeling photon migration and predicting exit patterns.

6. Potential for Non-Invasive Detection: The simulation demonstrates that DOT can differentiate between healthy tissue and hemorrhagic lesions based on differences in light absorption, making it a promising tool for non-invasive brain imaging, particularly in infants.

7. Optimization of Measurement Setup: The study provides insights into optimizing the placement of sources and detectors to maximize sensitivity to specific tissue abnormalities, which is essential for improving the accuracy of DOT image reconstruction.

8. Cost-Effective and Accessible Imaging: DOT's low cost and portability make it suitable for use in neonatal intensive care units (NICUs) and remote areas, offering a safer alternative to traditional imaging methods that use ionizing radiation.

9. Functional Imaging Capabilities: Beyond structural imaging, DOT has the potential to monitor functional parameters like blood oxygenation levels, which is particularly useful for assessing brain function in premature infants and detecting early signs of hypoxia.


