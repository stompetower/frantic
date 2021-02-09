namespace FranticMapMaker
{
    partial class Form1
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            this.makeMapButton = new System.Windows.Forms.Button();
            this.franticJobUpDown = new System.Windows.Forms.NumericUpDown();
            this.label1 = new System.Windows.Forms.Label();
            this.isNeutralBG = new System.Windows.Forms.CheckBox();
            ((System.ComponentModel.ISupportInitialize)(this.franticJobUpDown)).BeginInit();
            this.SuspendLayout();
            // 
            // makeMapButton
            // 
            this.makeMapButton.Location = new System.Drawing.Point(47, 172);
            this.makeMapButton.Name = "makeMapButton";
            this.makeMapButton.Size = new System.Drawing.Size(127, 48);
            this.makeMapButton.TabIndex = 1;
            this.makeMapButton.Text = "Make Map";
            this.makeMapButton.UseVisualStyleBackColor = true;
            this.makeMapButton.Click += new System.EventHandler(this.makeMapButton_Click);
            // 
            // franticJobUpDown
            // 
            this.franticJobUpDown.Location = new System.Drawing.Point(105, 69);
            this.franticJobUpDown.Maximum = new decimal(new int[] {
            6,
            0,
            0,
            0});
            this.franticJobUpDown.Minimum = new decimal(new int[] {
            1,
            0,
            0,
            0});
            this.franticJobUpDown.Name = "franticJobUpDown";
            this.franticJobUpDown.Size = new System.Drawing.Size(60, 20);
            this.franticJobUpDown.TabIndex = 2;
            this.franticJobUpDown.Value = new decimal(new int[] {
            1,
            0,
            0,
            0});
            // 
            // label1
            // 
            this.label1.AutoSize = true;
            this.label1.Location = new System.Drawing.Point(25, 71);
            this.label1.Name = "label1";
            this.label1.Size = new System.Drawing.Size(62, 13);
            this.label1.TabIndex = 4;
            this.label1.Text = "Frantic Job:";
            // 
            // isNeutralBG
            // 
            this.isNeutralBG.AutoSize = true;
            this.isNeutralBG.Checked = true;
            this.isNeutralBG.CheckState = System.Windows.Forms.CheckState.Checked;
            this.isNeutralBG.Location = new System.Drawing.Point(28, 113);
            this.isNeutralBG.Name = "isNeutralBG";
            this.isNeutralBG.Size = new System.Drawing.Size(121, 17);
            this.isNeutralBG.TabIndex = 5;
            this.isNeutralBG.Text = "Neutral Background";
            this.isNeutralBG.UseVisualStyleBackColor = true;
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(6F, 13F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(188, 234);
            this.Controls.Add(this.isNeutralBG);
            this.Controls.Add(this.label1);
            this.Controls.Add(this.franticJobUpDown);
            this.Controls.Add(this.makeMapButton);
            this.FormBorderStyle = System.Windows.Forms.FormBorderStyle.FixedSingle;
            this.Name = "Form1";
            this.Text = "Form1";
            this.Load += new System.EventHandler(this.Form1_Load);
            ((System.ComponentModel.ISupportInitialize)(this.franticJobUpDown)).EndInit();
            this.ResumeLayout(false);
            this.PerformLayout();

        }

        #endregion
        private System.Windows.Forms.Button makeMapButton;
        private System.Windows.Forms.NumericUpDown franticJobUpDown;
        private System.Windows.Forms.Label label1;
        private System.Windows.Forms.CheckBox isNeutralBG;
    }
}

