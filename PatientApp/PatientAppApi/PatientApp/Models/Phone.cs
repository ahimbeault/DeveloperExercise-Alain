using System;
using System.Collections.Generic;
using System.Linq;
using System.Threading.Tasks;
using Microsoft.EntityFrameworkCore.Metadata.Internal;
using System.ComponentModel.DataAnnotations;


namespace PatientApp.Models
{
    public enum PhoneType
    {
        Cell = 0,
        Home = 1,
        Work = 2

    }

    public class Phone
    {
        [Key]
        public Guid PhoneId { get; set; }
        
        public string PhoneNumber { get; set; }
        
        public PhoneType PhoneType { get; set; }

        public Patient Patient { get; set; }
        [Required]
        public Guid? PatientId { get; set; }
    }
}
