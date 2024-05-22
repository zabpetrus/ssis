using System;
using System.IO;
using System.Reflection;
using System.Runtime.CompilerServices;
using System.Security.Cryptography;
using System.Text;
using System.Text.RegularExpressions;

namespace ElimWebApplication.InfraData.Context
{
    public class GetDecoderString
    {
        private static string GetDecryptedConnectionString()
        {
            string encryptedConnectionString = File.ReadAllText("database.config");
            string decryptedConnectionString = DecryptString(encryptedConnectionString);
            return decryptedConnectionString;
        }


        private static string ClearStringFromFile( string completeConnectionStringfromFile )
        {
            //Ver se tem o nome "ElimWebConnection:"

            string pattern = @"ElimWebConnection: ""(.+)""";
            Match match = Regex.Match(completeConnectionStringfromFile, pattern);
            if (match.Success)
            {
                return  match.Groups[1].Value;
                // Agora connectionInfo contém apenas a parte relevante da conexão
            }
            else{
               // Teoricamente, nao tem
               return completeConnectionStringfromFile;
            }
        }

        private static string GetClearConnectionString()
        {
            string configFilePath = @"F:\database.config";

            try
            {
                if (File.Exists(configFilePath))
                {
                    string conectionstring = File.ReadAllText(configFilePath);
                    return ClearStringFromFile(conectionstring);
                }
                else
                {
                    throw new FileNotFoundException("O arquivo database.config não foi encontrado.", configFilePath);
                }
            }
            catch (FileNotFoundException ex)
            {
                Console.Error.WriteLine("Erro ao ler o arquivo: " + ex.Message);
                throw; // Re-lança a exceção para ser tratada em outro lugar, se necessário
            }
            catch (Exception ex)
            {
                Console.Error.WriteLine("Erro genérico ao ler o arquivo: " + ex.Message);
                return ""; // Retorna null no caso de erro bizarro
            }
        }


        private static string DecryptString(string encryptedText)
        {
            // Implemente seu algoritmo de descriptografia aqui
            // Exemplo simples com AesManaged:
            using (Aes aes = Aes.Create())
            {
                byte[] key = Encoding.UTF8.GetBytes("chave-de-criptografia");
                byte[] iv = Encoding.UTF8.GetBytes("vetor-de-inicializacao");

                aes.Key = key;
                aes.IV = iv;

                ICryptoTransform decryptor = aes.CreateDecryptor(aes.Key, aes.IV);

                using (MemoryStream msDecrypt = new MemoryStream(Convert.FromBase64String(encryptedText)))
                {
                    using (CryptoStream csDecrypt = new CryptoStream(msDecrypt, decryptor, CryptoStreamMode.Read))
                    {
                        using (StreamReader srDecrypt = new StreamReader(csDecrypt))
                        {
                            return srDecrypt.ReadToEnd();
                        }
                    }
                }
            }
        }

        public static string GetClearString()
        {
            return GetClearConnectionString();
        }

        public static string GetDecryptedString()
        {
            return GetDecryptedConnectionString();
        }
    }
}
