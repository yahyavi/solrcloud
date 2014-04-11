import java.util.Random;

import org.apache.solr.client.solrj.SolrQuery;
import org.apache.solr.client.solrj.impl.HttpSolrServer;
import org.apache.solr.client.solrj.response.QueryResponse;
import org.apache.solr.common.SolrDocumentList;

public class QueryLoop implements Runnable{
	HttpSolrServer[] solr_nodes;
	int node_num;
	String[] qs;
	int len = -1;
	
	QueryLoop(HttpSolrServer[] slrn, int n, String[] q){
		solr_nodes = slrn;
		node_num = n;
		qs = q;
		len = q.length;
	}
	
	
@Override
	public void run() {
		Random ran = new Random();
		long querycount = 1;
		long resultcount= 1;
		long oldresultcount = 1;
		long time = System.currentTimeMillis();
		System.out.println("Starting");
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
			try{
				QueryResponse response = solr_nodes[node_num].query(query);
				results = response.getResults();
				querycount++;
				for (int i = 0; i < results.size(); ++i) {
//				  System.out.println(results.get(i));
				  resultcount++;
					}
			
				}catch(Exception e){
					e.printStackTrace();
			}
			
			if( (querycount % 1000) == 1 ){
				long newtime = System.currentTimeMillis();
				System.out.println("1000 Queries, Time passed: " + (newtime - time) + ", #doc results: " + (resultcount - oldresultcount) );
				System.out.println(query);
//				System.out.println(results);
				
				time = newtime;
				oldresultcount = resultcount;
			}
			
		}
	}
}

