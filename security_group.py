import matplotlib.pyplot as plt
import matplotlib.patches as patches

fig, ax = plt.subplots(figsize=(12, 6))
ax.set_xlim(0, 12)
ax.set_ylim(0, 6)
ax.axis('off')

# EC2-A and Security Group A
sg_a = patches.FancyBboxPatch((1, 3.5), 3, 2, boxstyle="round,pad=0.1", edgecolor='blue', facecolor='aliceblue', linestyle='--')
ec2_a = patches.FancyBboxPatch((1.75, 4.25), 1.5, 1, boxstyle="round,pad=0.1", edgecolor='black', facecolor='lightblue')

# EC2-B and Security Group B
sg_b = patches.FancyBboxPatch((8, 3.5), 3, 2, boxstyle="round,pad=0.1", edgecolor='green', facecolor='honeydew', linestyle='--')
ec2_b = patches.FancyBboxPatch((8.75, 4.25), 1.5, 1, boxstyle="round,pad=0.1", edgecolor='black', facecolor='lightgreen')

# Add the elements to the plot
ax.add_patch(sg_a)
ax.add_patch(ec2_a)
ax.add_patch(sg_b)
ax.add_patch(ec2_b)

# Labels
ax.text(2.5, 5.4, "Security Group A", ha='center', fontsize=11, color='blue')
ax.text(2.5, 4.75, "EC2-A", ha='center', fontsize=12)

ax.text(9.5, 5.4, "Security Group B", ha='center', fontsize=11, color='green')
ax.text(9.5, 4.75, "EC2-B", ha='center', fontsize=12)

# Communication arrow
ax.annotate("HTTP (Port 80)", xy=(8, 4.75), xytext=(5, 4.75),
            arrowprops=dict(arrowstyle="->", lw=2), fontsize=11)

# Explanation
ax.text(6, 2.5, "SG-B Inbound Rule:\nAllow HTTP from Security Group A", ha='center', fontsize=11)

plt.tight_layout()
plt.show()
