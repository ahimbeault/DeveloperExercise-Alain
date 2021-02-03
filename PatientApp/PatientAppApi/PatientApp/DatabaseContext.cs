using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;using Microsoft.EntityFrameworkCore;
using PatientApp.Models;

namespace PatientApp
{
    public class DatabaseContext : DbContext
    {
        #region Datasets for DBContext
        public DbSet<Patient> Patients { get; set; }

        public DbSet<Phone> Phones { get; set; }
        #endregion

        #region Constructors
        public DatabaseContext(DbContextOptions<DatabaseContext> options) : base(options) { }

        #endregion

        #region Protected Override Methods
        protected override void OnModelCreating(ModelBuilder modelBuilder)
        {
            SetupPatientSystem(ref modelBuilder);
        }
       #endregion

        #region Private Methods
        private void SetupPatientSystem(ref ModelBuilder modelBuilder)
        {
            modelBuilder.Entity<Patient>()
                .HasMany(p => p.Phones)
                .WithOne(ph => ph.Patient);
        }
        #endregion
    }
}
