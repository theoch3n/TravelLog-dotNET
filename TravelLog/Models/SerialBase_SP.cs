using Microsoft.CodeAnalysis.Elfie.Diagnostics;
using Microsoft.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Data;
using TravelLog.Models;

public class SerialBase_SP
{
    private string _SystemCode;
    private int _AddDay;
    string strConn = "server=DESKTOP-VK5815U;database=TravelLog;UID=JEC;PWD=J1234;";

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

    /// <author>濟恩</author>
    /// <summary>
    /// 使用預存程序取得流水號
    /// </summary>
    /// <returns>DataSet</returns>
    /// <exception cref="ApplicationException"></exception>
    public DataSet get_SerialNumber()
    {
        SqlConnection conn = new SqlConnection(strConn);
        DataSet DataInfo = new DataSet();
        DataSet ds = new DataSet();

        try
        {
            SqlDataAdapter adpt = new SqlDataAdapter();
            SqlCommand cmd = new SqlCommand();

            cmd.CommandText = "get_SerialNumber";
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Connection = conn;

            cmd.Parameters.AddWithValue("@SystemCode", _SystemCode);
            cmd.Parameters.AddWithValue("@AddDay", _AddDay);

            adpt.SelectCommand = cmd;
            adpt.Fill(ds);
        }

        catch (Exception ex)
        {
            throw new ApplicationException("Error fetching serial table.", ex);
        }
        finally
        {
            conn.Close();
            conn.Dispose();
        }

        return ds;
    }

    /// <author>濟恩</author>
    /// <summary>
    /// 使用預存程序取得流水號 回傳型態List<SerialBase>
    /// 若要使用cmd.ExecuteReader() 請使用dt.Load
    /// SqlDataReader reader 尚且有問題(未解決)
    /// </summary>
    /// <returns>List<SerialBase></returns>
    /// <exception cref="ApplicationException"></exception>
    public List<SerialBase> GetSerialTable()
    {
        List<SerialBase> serialTable = new List<SerialBase>();

        try
        {
            SqlConnection conn = new SqlConnection(strConn);


            SqlCommand cmd = new SqlCommand();

            cmd.CommandText = "get_SerialNumber";
            cmd.CommandType = CommandType.StoredProcedure;
            cmd.Connection = conn;
            conn.Open();

            cmd.Parameters.AddWithValue("@SystemCode", _SystemCode);
            cmd.Parameters.AddWithValue("@AddDay", _AddDay);

            DataTable dt = new DataTable();
            dt.Load(cmd.ExecuteReader());

            //SqlDataReader reader = cmd.ExecuteReader(); 
            //if (reader.Read())
            //{
            //    // 建立 SerialBase 的實例，並從 SqlDataReader 中取值
            //    SerialBase row = new SerialBase
            //    {
            //        SbSerial = reader["SB_Serial"] != DBNull.Value ? Int32.Parse(reader["SerialNumber"].ToString()) : 0,
            //        SbSystemCode = reader["SB_SystemCode"]?.ToString(),
            //        SbSystemName = reader["SB_SystemName"]?.ToString(),
            //        SbSerialNumber = reader["SB_SerialNumber"]?.ToString(),
            //        SbCount = reader["SB_Count"] != DBNull.Value ? Int32.Parse(reader["SbCount"].ToString()) : 0,
            //        ModifiedDate = reader["ModifiedDate"] != DBNull.Value ? DateTime.Parse(reader["ModifiedDate"].ToString()) : DateTime.MinValue
            //    };

            //    // 將該行加入到列表中
            //    serialTable.Add(row);
            //}
            conn.Close();
        }
        catch (Exception ex)
        {
            throw new ApplicationException("Error fetching serial table.", ex);
        }

        return serialTable;
    }
}
