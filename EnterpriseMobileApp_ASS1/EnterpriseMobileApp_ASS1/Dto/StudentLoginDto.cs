using System.ComponentModel.DataAnnotations;

namespace EnterpriseMobileApp_ASS1.DTO
{
    public class StudentLoginDto
    {
        [Required(ErrorMessage ="User Name Is Required")]
        public string Name  { get; set; }
        [Required(ErrorMessage = "password Is Required")]
        public string password { get; set; }
       
    }
}
