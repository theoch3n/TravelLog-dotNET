using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using TravelLog.Models;

public class SerialBase_SP
{
    private string _SystemCode;
    private int _AddDay;
    string strConn = "server=.;database=TravelLog;";

    public SerialBase_SP(string SystemCode, int AddDay = 0)
    {
        _SystemCode = SystemCode;
    }

    public string SystemCode
    {
        get { return _SystemCode; }
        set { _SystemCode = value; }
    }

    public int AddDay
    {
        get { return _AddDay; }
        set { _AddDay = value; }
    }

    public List<SerialBase> GetSerialTable()
    {
        List<SerialBase> serialTable = new List<SerialBase>();

        try
        {
            using (SqlConnection conn = new SqlConnection(strConn))
            {
                conn.Open();

                using (SqlCommand cmd = new SqlCommand("get_SerialNumber", conn))
                {
                    cmd.CommandType = CommandType.StoredProcedure;

                    cmd.Parameters.AddWithValue("@SystemCode", _SystemCode);
                    cmd.Parameters.AddWithValue("@AddDay", _AddDay);

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            // 建立 SerialBase 的實例，並從 SqlDataReader 中取值
                            SerialBase row = new SerialBase
                            {
                                SbSerial = reader["SerialNumber"] != DBNull.Value ? Int32.Parse(reader["SerialNumber"].ToString()) : 0,
                                SbSystemCode = reader["SbSystemCode"]?.ToString(),
                                SbSystemName = reader["SbSystemName"]?.ToString(),
                                SbSerialNumber = reader["SbSerialNumber"]?.ToString(),
                                SbCount = reader["SbCount"] != DBNull.Value ? Int32.Parse(reader["SbCount"].ToString()) : 0,
                                ModifiedDate = reader["ModifiedDate"] != DBNull.Value ? DateTime.Parse(reader["ModifiedDate"].ToString()) : DateTime.MinValue
                            };

                            // 將該行加入到列表中
                            serialTable.Add(row);
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            throw new ApplicationException("Error fetching serial table.", ex);
        }

        return serialTable;
    }
}
