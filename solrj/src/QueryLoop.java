import java.io.BufferedWriter;
import java.io.FileWriter;
import java.net.InetAddress;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.Random;

import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.client.solrj.impl.HttpSolrServer;
import org.apache.solr.client.solrj.response.QueryResponse;
import org.apache.solr.common.SolrDocumentList;

public class QueryLoop implements Runnable{
	HttpSolrServer solr_node = null;
	String[] hosts;
	int node_num;
	String[] qs;
	String date = "";
	int len = -1;
	int thread_num = -1;
	int jettyport = -1;
	int zk_num = -1;
	int shard_num = -1;
	
	QueryLoop(String[] hs, int t_num, String[] q, int n_num, int jp, String dt, int zk, int sn){
		hosts = hs;
		node_num = n_num;
		thread_num = t_num;
		qs = q;
		len = q.length;
		jettyport = jp;
		date = dt;
		zk_num = zk;
		shard_num = sn;
		
		
		
		  String server = String.format("http://%s:%d/solr", hosts[thread_num%node_num], jettyport+(thread_num%node_num));
		  System.out.println(server);
		  try{
			  solr_node = new HttpSolrServer(server);
		  }catch(Exception e){
			  e.printStackTrace();
		  }
		  
		
	}
	
	
@Override
	public void run() {
		Random ran = new Random();
		long querycount = 1;
		long resultcount= 1;
		long oldresultcount = 1;
		long time = System.currentTimeMillis();
		double timesum = 0;
		int seccount = 0;
		System.out.println("Starting");

		BufferedWriter out = null;
		
		try{
//			Process p = Runtime.getRuntime().exec("hostname");
			InetAddress addr = InetAddress.getLocalHost();
			String hostname = addr.getHostName();
			String fname = date + "_" +hostname.toString() +"_N" + node_num  + "_S" + shard_num + "_Z" + zk_num + "_T" + thread_num + ".log";
			System.out.println(fname);
			
		    FileWriter fstream = new FileWriter(fname, false); //true tells to append data.
		    out = new BufferedWriter(fstream);
			while(true){
				
				SolrQuery query = new SolrQuery();
				query.setQuery(qs[ran.nextInt(len)]);
	//			query.setQuery("test sony");
				//query.addFilterQuery("cat:electronics","store:amazon.com");
	//			query.addFilterQuery("blogurl:"+"http\\" + "://www.bloomberg.com");
	//			query.setFields("id","blogurl","url","published");
	//			query.set("defType", "edismax");
	//			query.setStart(0);    
			
	//			System.out.println(query.toString());
				SolrDocumentList results = null;
					QueryResponse response = solr_node.query(query);
					results = response.getResults();
					querycount++;
					for (int i = 0; i < results.size(); ++i) {
	//				  System.out.println(results.get(i));
					  resultcount++;
						}
				
				
				if( (querycount % 1000) == 1 ){
					long newtime = System.currentTimeMillis();
					System.out.println("ThreadID: " + thread_num + ", 1000 Queries, Time passed: " + (newtime - time) + ", #doc results: " + (resultcount - oldresultcount) );
					System.out.println(query);
	//				System.out.println(results);
					out.write("ThreadID: " + thread_num + ", 1000 Queries, Time passed: " + (newtime - time) + ", #doc results: " + (resultcount - oldresultcount) + "\n" );
					out.flush();
					timesum += newtime - time;
					
					time = newtime;
					oldresultcount = resultcount;
					seccount++;
					if (seccount>=900){
						out.write("Average Time:"+ timesum/seccount +"\n");
						out.flush();
						System.out.println(("Average Time:"+ timesum/seccount +"\n"));
						break;
					}
					}
				
			}//while
			
		} catch(Exception e){
			e.printStackTrace();
			System.exit(-1);
		}
		try{ 
			if (out != null){
				out.close();
			}
		}catch(Exception e){
			e.printStackTrace();
		}
		
	}

}

